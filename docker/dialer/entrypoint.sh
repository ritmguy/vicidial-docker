#!/bin/bash
# Runtime server registration/alignment + conferencing/timing setup.
# VICIdial registers a server against a LIVE DB, but install.pl runs at image
# build time (no DB). The DB is seeded with a placeholder server (10.10.10.15);
# here we align it to this host's IP in both the DB and astguiclient.conf, set
# the conferencing engine, pick the timing source, then hand off to supervisord.
# Passing VICI_HOST at runtime means an IP change is a restart, not a rebuild.
set -e
# Prefer the runtime env; fall back to whatever was baked into astguiclient.conf.
VICI_HOST="${VICI_HOST:-$(sed -n 's/^VARserver_ip *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')}"
SEED_IP="10.10.10.15"

# DB creds straight from astguiclient.conf (authoritative for VICIdial).
DBNAME=$(sed -n 's/^VARDB_database *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBUSER=$(sed -n 's/^VARDB_user *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBPASS=$(sed -n 's/^VARDB_pass *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')

# The database host comes from the runtime environment, not the image. VARDB_server
# is baked at build time, so honouring it first made VICI_DB a no-op. VICIdial's own
# Perl scripts read astguiclient.conf, so rewrite the file too -- otherwise the
# entrypoint would talk to one database while the cron jobs talked to another.
DBHOST="${VICI_DB:-$(sed -n 's/^VARDB_server *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')}"
DBHOST="${DBHOST:-127.0.0.1}"
CONF_DBHOST=$(sed -n 's/^VARDB_server *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
if [ "$CONF_DBHOST" != "$DBHOST" ]; then
  echo "[entrypoint] pointing astguiclient.conf at database ${DBHOST} (was ${CONF_DBHOST})"
  sed -i "s|^VARDB_server *=>.*|VARDB_server => ${DBHOST}|" /etc/astguiclient.conf
fi

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

# Work out WHICH server row belongs to this node before touching anything.
#
# A node's stable identity is VICIdial's server_id (a UNIQUE key on `servers`).
# server_ip cannot serve as the identity here, because a changed IP is exactly
# what we may need to correct. Set VICI_SERVER_ID whenever more than one server
# shares this database; with a single server it can be left unset.
#
# This must never guess. Picking "the first row" would, with two dialers, make
# each one rewrite the other's registration on every restart -- they would steal
# each other's identity in a loop, corrupting both the DB and astguiclient.conf.
TARGET_ID="${VICI_SERVER_ID:-}"
SRV_COUNT=$(mysql_q "SELECT COUNT(*) FROM servers;")
SRV_COUNT="${SRV_COUNT:-0}"
CUR_IP=""
ALIGN=0

if [ -z "$DBUSER" ] || [ -z "$VICI_HOST" ]; then
  echo "[entrypoint] no DB credentials or server IP; skipping server registration"
elif [ -n "$TARGET_ID" ]; then
  CUR_IP=$(mysql_q "SELECT server_ip FROM servers WHERE server_id='$TARGET_ID';")
  if [ -n "$CUR_IP" ]; then
    ALIGN=1
  else
    echo "[entrypoint] WARNING: no server row has server_id='${TARGET_ID}'."
    echo "[entrypoint] Refusing to touch any other server's registration. Add this"
    echo "[entrypoint] server in the VICIdial admin UI, or correct VICI_SERVER_ID."
  fi
elif [ "$SRV_COUNT" -eq 1 ]; then
  CUR_IP=$(mysql_q "SELECT server_ip FROM servers;")
  ALIGN=1
elif [ "$SRV_COUNT" -eq 0 ]; then
  echo "[entrypoint] no server rows yet; nothing to align"
else
  echo "[entrypoint] ============================ WARNING ============================"
  echo "[entrypoint] ${SRV_COUNT} servers share this database, but VICI_SERVER_ID is not"
  echo "[entrypoint] set, so this node cannot tell which row is its own."
  echo "[entrypoint] SKIPPING server-IP alignment rather than risk overwriting"
  echo "[entrypoint] another dialer's registration."
  echo "[entrypoint] Fix: set VICI_SERVER_ID to this node's server_id, e.g."
  echo "[entrypoint]   environment: [ VICI_SERVER_ID=dialer1 ]"
  echo "[entrypoint] ================================================================="
fi

if [ "$ALIGN" -eq 1 ] && [ "$CUR_IP" != "$VICI_HOST" ]; then
  echo "[entrypoint] aligning registered server ${CUR_IP} -> ${VICI_HOST}"
  ( cd /usr/share/astguiclient/trunk/bin && \
    perl ADMIN_update_server_ip.pl --auto --old-server_ip="$CUR_IP" --server_ip="$VICI_HOST" ) 2>&1 | tail -4 \
    || echo "[entrypoint] ADMIN_update_server_ip.pl returned nonzero (continuing)"
elif [ "$ALIGN" -eq 1 ]; then
  echo "[entrypoint] server already registered as ${VICI_HOST}"
fi

# Conferencing engine: this image builds ConfBridge only (app_meetme is NOT
# compiled), so the server's conf_engine MUST be CONFBRIDGE or VICIdial would
# try to use the missing MeetMe app. ADMIN_keepalive_ALL.pl (cron) then reads
# conf_engine and generates confbridge-vicidial.conf from vicidial_confbridges.
# Scoped to this node only -- by server_id when known, else by this host's IP.
if [ -n "$DBUSER" ] && [ -n "$VICI_HOST" ]; then
  if [ -n "$TARGET_ID" ]; then
    CE_WHERE="server_id='$TARGET_ID'"
  else
    CE_WHERE="server_ip='$VICI_HOST'"
  fi
  echo "[entrypoint] setting conf_engine=CONFBRIDGE where ${CE_WHERE}"
  mysql_q "UPDATE servers SET conf_engine='CONFBRIDGE' WHERE ${CE_WHERE};" \
    || echo "[entrypoint] conf_engine UPDATE returned nonzero (continuing)"
fi

# Timing source. VICIdial's ConfBridge documentation calls for DAHDI timing:
# Asterisk's default res_timing_timerfd is disturbed every time Asterisk forks,
# which VICIdial does constantly for AGI, and that makes ConfBridge skip audio
# frames. So when /dev/dahdi/timer is mapped in (the default -- see the dialer
# `devices:` block in docker-compose.yaml) we noload the userspace timers, which
# leaves res_timing_dahdi as the only timing interface Asterisk can pick.
if [ -c /dev/dahdi/timer ]; then
  echo "[entrypoint] /dev/dahdi/timer present -> DAHDI timing (recommended)"
  grep -q '^noload => res_timing_timerfd.so' /etc/asterisk/modules.conf || \
    printf '\nnoload => res_timing_timerfd.so\nnoload => res_timing_kqueue.so\nnoload => res_timing_pthread.so\n' >> /etc/asterisk/modules.conf
else
  echo "[entrypoint] ============================ WARNING ============================"
  echo "[entrypoint] No /dev/dahdi/timer -- falling back to Asterisk's timerfd timer."
  echo "[entrypoint] This is NOT RECOMMENDED FOR PRODUCTION. VICIdial forks heavily"
  echo "[entrypoint] for AGI, and timerfd is disturbed by those forks, which makes"
  echo "[entrypoint] ConfBridge skip audio frames -- heard as choppy conference audio"
  echo "[entrypoint] on a busy dialer. See VICIdial's ConfBridge documentation:"
  echo "[entrypoint]   https://www.vicidial.org/docs/ConfBridge%20Documentation.txt"
  echo "[entrypoint] Fix: load the dahdi kmod on this host (see README, 'Dialer host"
  echo "[entrypoint] requirements') so the default device mapping can be used."
  echo "[entrypoint] ================================================================="
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
