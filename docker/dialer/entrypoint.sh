#!/bin/bash
# Runtime server registration/alignment + conferencing/timing setup.
# VICIdial registers a server against a LIVE DB, but install.pl runs at image
# build time (no DB). The DB is seeded with a placeholder server (10.10.10.15);
# here we align it to this host's IP in both the DB and astguiclient.conf, set
# the conferencing engine, pick the timing source, then hand off to supervisord.
# Passing VICI_HOST at runtime means an IP change is a restart, not a rebuild.
set -e
VICI_DB="${VICI_DB:-127.0.0.1}"
# Prefer the runtime env; fall back to whatever was baked into astguiclient.conf.
VICI_HOST="${VICI_HOST:-$(sed -n 's/^VARserver_ip *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')}"
SEED_IP="10.10.10.15"

# DB creds straight from astguiclient.conf (authoritative for VICIdial).
DBHOST=$(sed -n 's/^VARDB_server *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBNAME=$(sed -n 's/^VARDB_database *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBUSER=$(sed -n 's/^VARDB_user *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBPASS=$(sed -n 's/^VARDB_pass *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBHOST="${DBHOST:-$VICI_DB}"

# Debian trixie ships the MariaDB 11.x client, which requires TLS by default,
# while the bundled 10.11 server offers none -- the CLI then dies with
# "SSL is required, but the server does not support it". These calls are local
# (loopback/host net), and VICIdial's own PHP/Perl already connect in plaintext,
# so force plaintext here too. Without this the conf_engine UPDATE below is a
# silent no-op on Debian.
MYSQL_OPTS="--skip-ssl"
mysql_q() { mysql $MYSQL_OPTS -h "$DBHOST" -u"$DBUSER" -p"$DBPASS" "$DBNAME" -N -B -e "$1" 2>/dev/null; }

echo "[entrypoint] server IP=${VICI_HOST:-unknown}; waiting for DB ${DBHOST}:3306 ..."
for i in $(seq 1 60); do
  mysqladmin $MYSQL_OPTS ping -h "$DBHOST" --silent 2>/dev/null && break
  sleep 2
done

# Align the registered server row to this host's IP. Align from whatever is
# CURRENTLY registered rather than only the seed IP: on a rebuilt container with
# an existing DB volume the row already holds a previous host IP, and keying off
# the seed would silently leave it stale after a network change. Single-host
# all-in-one image, so the first row is the server.
if [ -n "$VICI_HOST" ] && [ -n "$DBUSER" ]; then
  CUR_IP=$(mysql_q "SELECT server_ip FROM servers LIMIT 1;")
  CUR_IP="${CUR_IP:-$SEED_IP}"
  if [ "$CUR_IP" != "$VICI_HOST" ]; then
    echo "[entrypoint] aligning registered server ${CUR_IP} -> ${VICI_HOST}"
    ( cd /usr/share/astguiclient/trunk/bin && \
      perl ADMIN_update_server_ip.pl --auto --old-server_ip="$CUR_IP" --server_ip="$VICI_HOST" ) 2>&1 | tail -4 \
      || echo "[entrypoint] ADMIN_update_server_ip.pl returned nonzero (continuing)"
  else
    echo "[entrypoint] server already registered as ${VICI_HOST}"
  fi
fi

# Conferencing engine: this image builds ConfBridge only (app_meetme is NOT
# compiled), so the server's conf_engine MUST be CONFBRIDGE or VICIdial would
# try to use the missing MeetMe app. ADMIN_keepalive_ALL.pl (cron) then reads
# conf_engine and generates confbridge-vicidial.conf from vicidial_confbridges.
if [ -n "$VICI_HOST" ] && [ -n "$DBUSER" ]; then
  echo "[entrypoint] setting conf_engine=CONFBRIDGE for ${VICI_HOST}"
  mysql_q "UPDATE servers SET conf_engine='CONFBRIDGE' WHERE server_ip='$VICI_HOST';" \
    || echo "[entrypoint] conf_engine UPDATE returned nonzero (continuing)"
fi

# Timing source. ConfBridge needs a timing interface; Asterisk's default
# res_timing_timerfd works in any container with no host dependency, so it is
# the default. If a host provides DAHDI timing (dahdi kmod loaded and the
# docker-compose.dahdi.yaml overlay maps /dev/dahdi/timer into the container),
# force DAHDI by noloading the userspace timers — VICIdial's traditional timer.
if [ -c /dev/dahdi/timer ]; then
  echo "[entrypoint] /dev/dahdi/timer present -> forcing DAHDI timing"
  grep -q '^noload => res_timing_timerfd.so' /etc/asterisk/modules.conf || \
    printf '\nnoload => res_timing_timerfd.so\nnoload => res_timing_kqueue.so\nnoload => res_timing_pthread.so\n' >> /etc/asterisk/modules.conf
else
  echo "[entrypoint] no /dev/dahdi/timer -> using default timerfd timing"
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
