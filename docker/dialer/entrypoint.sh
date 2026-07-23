#!/bin/bash
# Runtime server registration/alignment.
# VICIdial registers a server against a LIVE DB, but install.pl runs at image
# build time (no DB). The DB is seeded with a placeholder server (10.10.10.15);
# here we align it to this host's IP in both the DB and astguiclient.conf, then
# hand off to supervisord. Passing VICI_HOST at runtime means an IP change is a
# restart, not a rebuild.
set -e
VICI_DB="${VICI_DB:-127.0.0.1}"
# Prefer the runtime env; fall back to whatever was baked into astguiclient.conf.
VICI_HOST="${VICI_HOST:-$(sed -n 's/^VARserver_ip *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')}"
SEED_IP="10.10.10.15"

echo "[entrypoint] server IP=${VICI_HOST:-unknown}; waiting for DB ${VICI_DB}:3306 ..."
for i in $(seq 1 60); do
  mysqladmin ping -h "$VICI_DB" --silent 2>/dev/null && break
  sleep 2
done

if [ -n "$VICI_HOST" ] && [ "$VICI_HOST" != "$SEED_IP" ]; then
  echo "[entrypoint] aligning seeded server ${SEED_IP} -> ${VICI_HOST}"
  ( cd /usr/share/astguiclient/trunk/bin && \
    perl ADMIN_update_server_ip.pl --auto --old-server_ip="$SEED_IP" --server_ip="$VICI_HOST" ) 2>&1 | tail -4 \
    || echo "[entrypoint] ADMIN_update_server_ip.pl returned nonzero (continuing)"
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
