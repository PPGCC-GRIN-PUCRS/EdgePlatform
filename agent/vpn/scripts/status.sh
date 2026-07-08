#!/usr/bin/env bash
# Pretty Tailscale status (online peers only) from inside the Docker container.
# Usage: ./status.sh [container_name]
# Default container: "tailscale"

set -euo pipefail
CONTAINER="${1:-tailscale}"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker not found on host." >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required for this script." >&2
  exit 1
fi

# Grab JSON from container
if ! JSON="$(docker exec "$CONTAINER" tailscale status --json 2>/dev/null)"; then
  echo "ERROR: Could not exec 'tailscale status --json' in container '$CONTAINER'." >&2
  exit 2
fi

# 1) Turn JSON into TSV (header + rows)
TSV="$(
  printf '%s\n' "$JSON" | jq -r '
    def name(n): n.HostName // n.DNSName // n.Name // n.ComputedName // "unknown";
    def ts4(n): (n.TailscaleIPs // []) | map(select(contains(":")|not)) | join(",");
    def ts6(n): (n.TailscaleIPs // []) | map(select(contains(":")))     | join(",");
    def tags(n): (n.Tags // []) | join(",");

    # Accept both .Peer (map/array) and .Peers as fallback
    (
      ( .Peer // .Peers // {} ) as $p
      | if ($p | type) == "object" then ($p | to_entries | map(.value)) else ($p // []) end
      | map(select(.Online == true))
      | sort_by(name(.))
    ) as $peers
    |
    # Always emit header; then 0..N peer rows
    (["NAME","TS4","TS6","OS","TAGS"]),
    ($peers[]? | [ name(.), ts4(.), ts6(.), (.OS // ""), tags(.) ])
    | @tsv
  '
)"

# 2) If there are no rows beyond header, show a friendly message
if [ "$(printf '%s\n' "$TSV" | wc -l | tr -d ' ')" -le 1 ]; then
  # Still print header neatly, then a note
  printf '%s\n' "$TSV" | awk -F'\t' '
    NR==1 {
      for (i=1;i<=NF;i++) { w[i]=length($i); hdr[i]=$i }
      line=""
      for (i=1;i<=NF;i++) {
        printf "%-*s%s", w[i], hdr[i], (i<NF ? "  " : ORS)
      }
      # underline
      for (i=1;i<=NF;i++) {
        printf "%-*s%s", w[i], gensub(/./,"-","g",sprintf("%"w[i]"s","")), (i<NF ? "  " : ORS)
      }
      print "No online peers."
      exit
    }
  '
  exit 0
fi

# 3) Pretty-print the TSV with awk (no boxes/bars)
printf '%s\n' "$TSV" | awk -F'\t' '
  {
    rows[NR]=$0
    if (NF>ncols) ncols=NF
    for (i=1;i<=NF;i++) {
      len=length($i)
      if (len>w[i]) w[i]=len
    }
  }
  END {
    # header
    split(rows[1], h, FS)
    for (i=1;i<=ncols;i++) {
      printf "%-*s%s", w[i], h[i], (i<ncols ? "  " : ORS)
    }
    # underline
    for (i=1;i<=ncols;i++) {
      dash=""
      for (k=1;k<=w[i];k++) dash=dash "-"
      printf "%-*s%s", w[i], dash, (i<ncols ? "  " : ORS)
    }
    # data rows
    for (r=2; r<=NR; r++) {
      split(rows[r], f, FS)
      for (i=1;i<=ncols;i++) {
        printf "%-*s%s", w[i], f[i], (i<ncols ? "  " : ORS)
      }
    }
  }  
'
