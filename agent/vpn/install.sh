#!/usr/bin/env bash

set -Eeuo pipefail


# ==============================================================================
# Configuration
# ==============================================================================

INSTALL_URL="https://raw.githubusercontent.com/PPGCC-GRIN-PUCRS/EdgePlatform/refs/heads/release/vpn/install.sh"

REPO_ARCHIVE_URL="https://github.com/PPGCC-GRIN-PUCRS/EdgePlatform/archive/refs/heads/release.tar.gz"

INSTALL_DIR="/opt/tailscale"
SCRIPTS_DIR="${INSTALL_DIR}/scripts"


# ==============================================================================
# Helpers
# ==============================================================================

log() {
  printf '\n[EdgePlatform] %s\n' "$*"
}


fail() {
  printf '\n[EdgePlatform] ERROR: %s\n' "$*" >&2
  exit 1
}


usage() {
  cat <<'EOF'

Usage:

  wget -qO- <install.sh-url> | bash -s -- <hostname> <tailscale-auth-key>

Example:

  wget -qO- \
    https://raw.githubusercontent.com/PPGCC-GRIN-PUCRS/EdgePlatform/refs/heads/release/vpn/install.sh \
    | bash -s -- rpi0 tskey-auth-REPLACE_ME

EOF
}


# ==============================================================================
# Arguments
# ==============================================================================

[[ $# -eq 2 ]] || {
  usage
  exit 2
}

NODE_HOSTNAME="$1"
TS_AUTHKEY_VALUE="$2"


[[ -n "${NODE_HOSTNAME}" ]] \
  || fail "hostname cannot be empty"


[[ "${NODE_HOSTNAME}" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*$ ]] \
  || fail "hostname contains invalid characters: ${NODE_HOSTNAME}"


[[ -n "${TS_AUTHKEY_VALUE}" ]] \
  || fail "Tailscale auth key cannot be empty"


case "${TS_AUTHKEY_VALUE}" in
  *$'\n'*|*$'\r'*)
    fail "Tailscale auth key must be a single line"
    ;;
esac


# ==============================================================================
# Root escalation
# ==============================================================================
#
# Because this script is normally executed through:
#
#   wget ... | bash -s -- ...
#
# re-executing $0 with sudo is not possible because $0 is bash, not the
# downloaded installer.
#
# Therefore, when the script detects a non-root shell, it downloads itself
# again and executes the second instance as root.
# ==============================================================================

if [[ ${EUID} -ne 0 ]]; then

  command -v sudo >/dev/null 2>&1 \
    || fail "sudo is required when not running as root"

  command -v wget >/dev/null 2>&1 \
    || fail "wget is required for privilege escalation"

  log "Re-running installer as root"

  exec sudo bash -c \
    'wget -qO- "$1" | bash -s -- "$2" "$3"' \
    _ \
    "${INSTALL_URL}" \
    "${NODE_HOSTNAME}" \
    "${TS_AUTHKEY_VALUE}"
fi


export DEBIAN_FRONTEND=noninteractive


# ==============================================================================
# Base packages
# ==============================================================================

log "Installing base packages"

apt-get update

apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  kmod \
  tar \
  wget


# ==============================================================================
# Docker
# ==============================================================================

if ! command -v docker >/dev/null 2>&1; then

  log "Installing Docker Engine"

  tmp_docker_script="$(mktemp)"

  curl -fsSL \
    https://get.docker.com \
    -o "${tmp_docker_script}"

  sh "${tmp_docker_script}"

  rm -f "${tmp_docker_script}"

else

  log "Docker is already installed"

fi


log "Enabling Docker service"

systemctl enable --now docker


# Ensure Docker Compose v2 is available

if ! docker compose version >/dev/null 2>&1; then

  log "Installing Docker Compose plugin"

  apt-get update

  apt-get install -y docker-compose-plugin

fi


# ==============================================================================
# TUN device
# ==============================================================================

log "Preparing TUN device"

modprobe tun

install -d -m 0755 /dev/net


if [[ ! -c /dev/net/tun ]]; then

  mknod /dev/net/tun c 10 200

fi


chmod 0666 /dev/net/tun


# ==============================================================================
# Tailscale installation directory
# ==============================================================================

log "Creating ${INSTALL_DIR}"

install -d -m 0755 "${INSTALL_DIR}"


# ==============================================================================
# docker-compose.yaml
# ==============================================================================

log "Writing docker-compose.yaml"

cat > "${INSTALL_DIR}/docker-compose.yaml" <<EOF
services:
  tailscale:
    container_name: tailscale
    image: tailscale/tailscale:stable
    network_mode: host
    hostname: ${NODE_HOSTNAME}
    env_file:
      - ./.env
    environment:
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_USERSPACE=false
    volumes:
      - ts-state:/var/lib/tailscale
      - /dev/net/tun:/dev/net/tun
    cap_add: [ "NET_ADMIN", "NET_RAW" ]
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "tailscale status --peers=false --json | grep -q '\"Online\": true' || tailscale status --peers=false --json | grep -q '\"Self\":.*\"Online\": true'"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 5s

volumes:
  ts-state:
EOF


chmod 0644 "${INSTALL_DIR}/docker-compose.yaml"


# ==============================================================================
# .env
# ==============================================================================

log "Writing .env"

umask 077


cat > "${INSTALL_DIR}/.env" <<EOF
TS_AUTHKEY=${TS_AUTHKEY_VALUE}
TS_EXTRA_ARGS=--login-server=https://vpn.logiclabsoftwares.com:443 --advertise-tags=tag:rpi
TS_HOSTNAME=${NODE_HOSTNAME}
TS_AUTH_ONCE=true
EOF


chmod 0600 "${INSTALL_DIR}/.env"


# ==============================================================================
# Download EdgePlatform VPN scripts
# ==============================================================================
#
# raw.githubusercontent.com does not provide wildcard directory downloads.
#
# Instead of maintaining a hardcoded filename list here, the installer:
#
#   1. downloads the release branch archive;
#   2. locates vpn/scripts;
#   3. copies its complete contents;
#   4. marks the files executable.
#
# This means new scripts added to vpn/scripts are automatically installed
# without requiring changes to install.sh.
# ==============================================================================

log "Downloading vpn/scripts from the release branch"


TMP_DIR="$(mktemp -d)"

trap 'rm -rf "${TMP_DIR}"' EXIT


curl -fsSL \
  "${REPO_ARCHIVE_URL}" \
  -o "${TMP_DIR}/release.tar.gz"


tar -xzf \
  "${TMP_DIR}/release.tar.gz" \
  -C "${TMP_DIR}"


SOURCE_SCRIPTS_DIR="$(
  find "${TMP_DIR}" \
    -type d \
    -path '*/vpn/scripts' \
    -print \
    -quit
)"


[[ -n "${SOURCE_SCRIPTS_DIR}" ]] \
  || fail "vpn/scripts directory was not found in the release branch archive"


# Remove old scripts so deleted repository scripts do not remain on the Pi.

rm -rf "${SCRIPTS_DIR}"

install -d -m 0755 "${SCRIPTS_DIR}"


cp -a \
  "${SOURCE_SCRIPTS_DIR}/." \
  "${SCRIPTS_DIR}/"


find "${SCRIPTS_DIR}" \
  -type f \
  -exec chmod 0755 {} +


# ==============================================================================
# Start Tailscale
# ==============================================================================

log "Starting Tailscale container"

cd "${INSTALL_DIR}"


docker compose pull


docker compose up \
  -d \
  --remove-orphans


# ==============================================================================
# Result
# ==============================================================================

log "Installation complete"


docker compose ps


printf '\nHostname: %s\n' "${NODE_HOSTNAME}"
printf 'Install directory: %s\n' "${INSTALL_DIR}"
printf 'Scripts directory: %s\n\n' "${SCRIPTS_DIR}"