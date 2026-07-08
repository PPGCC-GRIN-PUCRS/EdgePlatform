#!/usr/bin/env bash
# ts-health — Tailscale ↔ Headscale health check via container
# Env:
#   TAILSCALE_CONTAINER   (default: tailscale)
#   CONTAINER_RUNTIME     (default: docker)
#   HEADSCALE_URL         (default: https://vpn.logiclabsoftwares.com)
#   INSECURE=1            (allow -k for self-signed during tests)

set -euo pipefail

CNT="${TAILSCALE_CONTAINER:-tailscale}"
RT="${CONTAINER_RUNTIME:-docker}"
HS_URL="${HEADSCALE_URL:-https://vpn.logiclabsoftwares.com}"
API="${HS_URL%/}/api/v1/apikey"
INSEC="${INSECURE:-0}"

need(){ command -v "$1" >/dev/null 2>&1 || { echo "ERROR: $1 not found" >&2; exit 2; }; }
need "$RT"

rexec(){ "$RT" exec -i "$CNT" sh -lc "$*"; }

# container present?
if ! "$RT" ps --format '{{.Names}}' | grep -Fxq "$CNT"; then
  echo "ERROR: container '$CNT' not running" >&2; exit 1
fi

echo "== tailscale version =="
rexec 'tailscale version || true'
echo

echo "== login server (from prefs) =="
rexec 'tailscale debug prefs 2>/dev/null | sed -n "s/.*\"LoginURL\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"'
echo

echo "== control reachability =="
CODE=$(rexec "
  if command -v curl >/dev/null 2>&1; then
    CURLK=''; [ \"$INSEC\" = 1 ] && CURLK='-k';
    curl -fsS \$CURLK -o /dev/null -w '%{http_code}' -I '$API' || echo 000
  elif command -v wget >/dev/null 2>&1; then
    OUT=\$(wget $( [ \"$INSEC\" = 1 ] && echo '--no-check-certificate' ) -S --spider '$API' 2>&1 || true)
    echo \"\$OUT\" | awk '/HTTP\\//{code=\$2} END{if(code==\"\")code=0; print code+0}'
  else
    echo 000
  fi
")
case "$CODE" in
  200|401) echo "OK: $API reachable (HTTP $CODE)";;
  403)     echo "WARN: reachable but forbidden (HTTP 403)";;
  *)       echo "FAIL/WARN: HTTP $CODE (expected 200/401/403)";;
esac
echo

echo "== status (self + peers) =="
if rexec 'command -v jq >/dev/null'; then
  rexec 'tailscale status --json | jq -r " \"Self: \(.Self.HostName) Online=\(.Self.Online) IPs=\(.Self.TailscaleIPs|join(\",\"))\", \"Peers: \(.Peer|length) total\" "'
else
  rexec 'tailscale status || true'
fi
echo

echo "== netcheck =="
rexec 'tailscale netcheck || true'
echo

echo "== tailscale IPv4 =="
rexec 'tailscale ip -4 2>/dev/null || true'
echo

# pass/fail
if ! rexec 'tailscale status --peers=false >/dev/null 2>&1'; then
  echo "FAIL: tailscaled not responding inside container '$CNT'"; exit 1
fi
if [ "$CODE" = "200" ] || [ "$CODE" = "401" ] || [ "$CODE" = "403" ]; then
  echo "OK: tailscale is up and can talk to headscale."
  exit 0
else
  echo "WARN: tailscale up, but headscale reachability was HTTP $CODE"
  exit 0
fi
