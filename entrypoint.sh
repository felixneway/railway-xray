#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID environment variable must be set}"
WS_PATH="${WS_PATH:-/ray}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}", "flow": "" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom", "tag": "direct" } ]
}
EOF
exec /usr/local/bin/xray run -c /etc/xray/config.json
