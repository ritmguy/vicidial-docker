#!/bin/bash
# Write .env with this host's primary LAN IP.
#
# docker-compose automatically reads .env, so once this has run you don't need to
# `export LOCAL_IP` in every shell. Equivalent to:  echo "LOCAL_IP=<ip>" > .env
set -eu

# Use the source address of the route to the internet: that picks exactly ONE
# address even on a host with several interfaces (docker0, tailscale, VM bridges).
if command -v ip >/dev/null 2>&1; then                       # Linux
  LOCAL_IP=$(ip route get 1.1.1.1 2>/dev/null | sed -n 's/.*src \([0-9.]*\).*/\1/p' | head -1)
elif command -v ipconfig >/dev/null 2>&1; then               # macOS
  IFACE=$(route -n get 1.1.1.1 2>/dev/null | awk '/interface:/{print $2}')
  LOCAL_IP=$(ipconfig getifaddr "${IFACE:-en0}" 2>/dev/null || true)
else
  LOCAL_IP=""
fi

if [ -z "${LOCAL_IP:-}" ]; then
  echo "Could not determine this host's IP address." >&2
  echo "Set it by hand instead:  echo 'LOCAL_IP=<your.host.ip>' > .env" >&2
  exit 1
fi

if [ -f .env ]; then
  grep -v '^LOCAL_IP=' .env > .env.tmp || true
  mv .env.tmp .env
fi
echo "LOCAL_IP=${LOCAL_IP}" >> .env
echo "Wrote .env with LOCAL_IP=${LOCAL_IP}"
