#!/usr/bin/env bash
set -euo pipefail

DNS_IP="100.100.100.100"
RESOLV_CONF="/etc/resolv.conf"

# Must be root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root, e.g.: sudo $0" >&2
  exit 1
fi

if [ ! -e "$RESOLV_CONF" ]; then
  echo "Error: $RESOLV_CONF does not exist." >&2
  exit 1
fi

# Check if /etc/resolv.conf is a systemd-resolved stub
is_systemd_resolved=false
if [ -L "$RESOLV_CONF" ]; then
  target="$(readlink -f "$RESOLV_CONF" || true)"
  if echo "$target" | grep -q "systemd/resolve"; then
    is_systemd_resolved=true
  fi
fi

if [ "$is_systemd_resolved" = true ]; then
  echo "Detected systemd-resolved managing /etc/resolv.conf."
  echo "Configuring systemd-resolved to use DNS=$DNS_IP ..."

  mkdir -p /etc/systemd/resolved.conf.d
  DROPIN="/etc/systemd/resolved.conf.d/enable-magicdns.conf"

  # Backup existing drop-in if any
  if [ -f "$DROPIN" ]; then
    ts="$(date +%Y%m%d-%H%M%S)"
    cp "$DROPIN" "${DROPIN}.bak-${ts}"
    echo "Existing drop-in backed up to ${DROPIN}.bak-${ts}"
  fi

  cat > "$DROPIN" <<EOF
[Resolve]
DNS=$DNS_IP
EOF

  # Restart systemd-resolved to apply
  systemctl restart systemd-resolved

  echo "systemd-resolved configured. Current DNS status:"
  # This may fail on very old systems; ignore errors
  resolvectl status || true

  echo
  echo "Note: /etc/resolv.conf will still point to 127.0.0.53, but systemd-resolved"
  echo "now forwards queries upstream to $DNS_IP."
else
  echo "systemd-resolved stub not detected; editing $RESOLV_CONF directly."

  # If already present, do nothing
  if grep -qE "^\s*nameserver\s+$DNS_IP\s*$" "$RESOLV_CONF"; then
    echo "nameserver $DNS_IP is already present in $RESOLV_CONF"
    exit 0
  fi

  # Backup
  ts="$(date +%Y%m%d-%H%M%S)"
  backup="${RESOLV_CONF}.bak-${ts}"
  cp "$RESOLV_CONF" "$backup"
  echo "Backup created at: $backup"

  tmpfile="$(mktemp)"
  {
    echo "nameserver $DNS_IP"
    cat "$RESOLV_CONF"
  } > "$tmpfile"

  chmod --reference="$RESOLV_CONF" "$tmpfile" 2>/dev/null || true
  mv "$tmpfile" "$RESOLV_CONF"

  echo "Injected 'nameserver $DNS_IP' at the top of $RESOLV_CONF"
fi

