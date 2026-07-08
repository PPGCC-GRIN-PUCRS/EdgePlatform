```bash
#!/usr/bin/env bash

set -Eeuo pipefail


# ==============================================================================
# Configuration
# ==============================================================================

INSTALL_URL="https://raw.githubusercontent.com/PPGCC-GRIN-PUCRS/EdgePlatform/refs/heads/release/agent/vpn/install.sh"

REPO_ARCHIVE_URL="https://github.com/PPGCC-GRIN-PUCRS/EdgePlatform/archive/refs/heads/release.tar.gz"

INSTALL_DIR="/opt/tailscale"
SCRIPTS_DIR="${INSTALL_DIR}/scripts"


# ==============================================================================
# Helpers
# ==============================================================================

log() {
    printf '\n[EdgePlatform] %s\n' "$*"
}


warn() {
    printf '\n[EdgePlatform] WARNING: %s\n' "$*" >&2
}


fail() {
    printf '\n[EdgePlatform] ERROR: %s\n' "$*" >&2
    exit 1
}


usage() {
    cat <<EOF

Usage:

  wget -qO- \\
    ${INSTALL_URL} \\
    | bash -s -- <hostname> <tailscale-auth-key>

Example:

  wget -qO- \\
    ${INSTALL_URL} \\
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
# Detect operating system
# ==============================================================================

[[ -f /etc/os-release ]] \
    || fail "/etc/os-release was not found"


# shellcheck disable=SC1091
source /etc/os-release


OS_ID="${ID:-unknown}"
OS_VERSION="${VERSION_ID:-unknown}"
OS_CODENAME="${VERSION_CODENAME:-unknown}"


log "Detected OS: ${OS_ID} ${OS_VERSION} (${OS_CODENAME})"


# ==============================================================================
# APT repository repair
# ==============================================================================

repair_buster_sources() {

    if [[ "${OS_CODENAME}" != "buster" ]]; then
        return
    fi

    log "Raspberry Pi OS Buster detected"
    log "Switching Raspbian repository to legacy archive"

    BACKUP_DIR="/etc/apt/edgeplatform-backup-$(date +%Y%m%d-%H%M%S)"

    mkdir -p "${BACKUP_DIR}"


    if [[ -f /etc/apt/sources.list ]]; then
        cp /etc/apt/sources.list \
           "${BACKUP_DIR}/sources.list"
    fi


    if [[ -d /etc/apt/sources.list.d ]]; then
        cp -a /etc/apt/sources.list.d \
              "${BACKUP_DIR}/sources.list.d"
    fi


    # Main Raspbian Buster archive
    cat > /etc/apt/sources.list <<'EOF'
deb https://legacy.raspbian.org/raspbian/ buster main contrib non-free rpi
EOF


    mkdir -p /etc/apt/sources.list.d


    # Raspberry Pi-specific packages
    cat > /etc/apt/sources.list.d/raspi.list <<'EOF'
deb http://archive.raspberrypi.org/debian/ buster main
EOF


    # Disable any other old Buster source files that still reference the
    # retired raspbian.raspberrypi.org mirror.
    find /etc/apt/sources.list.d \
        -maxdepth 1 \
        -type f \
        -name '*.list' \
        ! -name 'raspi.list' \
        -print0 \
    | while IFS= read -r -d '' file; do

        if grep -q \
            'raspbian\.raspberrypi\.org.*buster' \
            "${file}"; then

            warn "Disabling obsolete repository file: ${file}"

            mv "${file}" "${file}.edgeplatform-disabled"

        fi

    done
}


repair_buster_sources


# ==============================================================================
# Update package index
# ==============================================================================

log "Updating package repositories"

apt-get update --allow-releaseinfo-change


# ==============================================================================
# Base packages
# ==============================================================================

log "Installing base packages"

apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    kmod \
    tar \
    wget


# ==============================================================================
# Docker installation
# ==============================================================================

install_docker_buster() {

    log "Installing Docker from the Docker Buster repository"

    install -m 0755 -d /etc/apt/keyrings


    curl -fsSL \
        https://download.docker.com/linux/raspbian/gpg \
        | gpg --dearmor \
            --yes \
            -o /etc/apt/keyrings/docker.gpg


    chmod a+r /etc/apt/keyrings/docker.gpg


    ARCH="$(dpkg --print-architecture)"


    cat > /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/raspbian buster stable
EOF


    apt-get update --allow-releaseinfo-change


    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}


install_docker_modern() {

    log "Installing Docker Engine"

    TMP_DOCKER_SCRIPT="$(mktemp)"


    curl -fsSL \
        https://get.docker.com \
        -o "${TMP_DOCKER_SCRIPT}"


    sh "${TMP_DOCKER_SCRIPT}"


    rm -f "${TMP_DOCKER_SCRIPT}"
}


if command -v docker >/dev/null 2>&1; then

    log "Docker is already installed"

else

    if [[ "${OS_CODENAME}" == "buster" ]]; then
        install_docker_buster
    else
        install_docker_modern
    fi

fi


# ==============================================================================
# Docker service
# ==============================================================================

log "Enabling Docker service"

systemctl enable --now docker


# ==============================================================================
# Validate Docker Compose
# ==============================================================================

if ! docker compose version >/dev/null 2>&1; then

    fail "Docker Compose plugin is not available"

fi


log "Docker version: $(docker --version)"
log "Compose version: $(docker compose version)"


# ==============================================================================
# Prepare TUN
# ==============================================================================

log "Preparing TUN device"


modprobe tun


install -d -m 0755 /dev/net


if [[ ! -c /dev/net/tun ]]; then

    mknod /dev/net/tun c 10 200

fi


chmod 0666 /dev/net/tun


# ==============================================================================
# Create installation directory
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
      test: ["CMD-SHELL", "tailscale status --peers=false --json | grep -q '\\\"Online\\\": true' || tailscale status --peers=false --json | grep -q '\\\"Self\\\":.*\\\"Online\\\": true'"]
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

log "Downloading agent/vpn/scripts from the release branch"


TMP_DIR="$(mktemp -d)"


cleanup() {
    rm -rf "${TMP_DIR}"
}


trap cleanup EXIT


curl -fsSL \
    "${REPO_ARCHIVE_URL}" \
    -o "${TMP_DIR}/release.tar.gz"


tar -xzf \
    "${TMP_DIR}/release.tar.gz" \
    -C "${TMP_DIR}"


SOURCE_SCRIPTS_DIR="$(
    find "${TMP_DIR}" \
        -type d \
        -path '*/agent/vpn/scripts' \
        -print \
        -quit
)"


[[ -n "${SOURCE_SCRIPTS_DIR}" ]] \
    || fail "agent/vpn/scripts directory was not found in the release branch"


rm -rf "${SCRIPTS_DIR}"


install -d -m 0755 "${SCRIPTS_DIR}"


cp -a \
    "${SOURCE_SCRIPTS_DIR}/." \
    "${SCRIPTS_DIR}/"


find "${SCRIPTS_DIR}" \
    -type f \
    -exec chmod 0755 {} +


# ==============================================================================
# Validate Docker Compose file
# ==============================================================================

log "Validating Docker Compose configuration"


cd "${INSTALL_DIR}"


docker compose config --quiet


# ==============================================================================
# Start Tailscale
# ==============================================================================

log "Pulling Tailscale image"


docker compose pull


log "Starting Tailscale container"


docker compose up \
    -d \
    --remove-orphans


# ==============================================================================
# Result
# ==============================================================================

log "Installation complete"


docker compose ps


printf '\n'
printf 'Hostname:          %s\n' "${NODE_HOSTNAME}"
printf 'Install directory: %s\n' "${INSTALL_DIR}"
printf 'Scripts directory: %s\n' "${SCRIPTS_DIR}"
printf '\n'
```
