#!/bin/bash
# Holder GitHub-redirecten i synk med gjeldende cloudflared-URL.
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
DIR=/Users/uponly/Antonsen/achilles-redirect
LOG=/Users/uponly/Antonsen/audit-scanner/tunnel.log

CUR=$(grep -Eo 'https://[a-z0-9-]+\.trycloudflare\.com' "$LOG" 2>/dev/null | tail -1)
[ -z "$CUR" ] && exit 0
INFILE=$(grep -Eo 'https://[a-z0-9-]+\.trycloudflare\.com' "$DIR/index.html" 2>/dev/null | head -1)
[ "$CUR" = "$INFILE" ] && exit 0   # uendret — ingenting å gjøre

/usr/bin/sed -i '' "s#https://[a-z0-9-]*\.trycloudflare\.com#$CUR#g" "$DIR/index.html"
/usr/bin/git -C "$DIR" add -A
/usr/bin/git -C "$DIR" -c user.name="Tidemann Esbjug" -c user.email="TidemannEsbjug@users.noreply.github.com" commit -m "oppdater tunnel-url" >/dev/null 2>&1
/usr/bin/git -C "$DIR" push >/dev/null 2>&1
echo "$(date '+%Y-%m-%d %H:%M:%S') -> $CUR" >> /Users/uponly/Antonsen/audit-scanner/url-sync.log
