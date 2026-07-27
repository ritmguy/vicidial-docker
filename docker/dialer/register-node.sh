#!/bin/bash
# Register an ADDITIONAL dialer in a shared VICIdial database.
#
#     docker-compose run --rm dialer register-node \
#         --server-id=dialer2 --description="Dialer 2"
#
# NOT needed for the first dialer. On a fresh database exactly one server row
# exists (the 10.10.10.15 seed from first_server_install.sql), so the
# entrypoint's SRV_COUNT==1 branch adopts it via ADMIN_update_server_ip.pl,
# which already rewrites every dependent row correctly. This script exists for
# node 2 onward, where that alignment deliberately refuses to guess which row
# is whose.
#
# A VICIdial server is not one row: the seed creates ~300 rows across five
# tables, and BOTH conference tables are keyed by server_ip. This script copies
# four of them -- servers, server_updater, conferences and vicidial_conferences.
# The fifth, `phones` (the gs102/callin demo entries), is deliberately NOT
# copied: those are demo extensions, not per-node configuration, so a new node
# correctly starts with none rather than inheriting someone else's phones.
#
# A servers row on its own produces a dialer that registers, appears healthy,
# and then fails the first time an agent tries to conference. So the conference
# extension list is COPIED from a server that already has one -- it therefore
# always matches whatever VICIdial's own schema seeded, instead of a hardcoded
# range that could drift when the upstream seed changes.
set -eu

DBHOST=""
SERVER_ID=""
SERVER_IP="${VICI_HOST:-}"
DESCRIPTION=""

for arg in "$@"; do
  case "$arg" in
    --db-host=*)     DBHOST="${arg#*=}" ;;
    --server-id=*)   SERVER_ID="${arg#*=}" ;;
    --server-ip=*)   SERVER_IP="${arg#*=}" ;;
    --description=*) DESCRIPTION="${arg#*=}" ;;
    *)
      echo "register-node: unknown option '${arg}'" >&2
      echo "usage: register-node --server-id=<id> [--description=<text>] [--server-ip=<ip>]" >&2
      exit 1 ;;
  esac
done

# server_id is varchar(10) with a UNIQUE key and is used unquoted in VICIdial's
# own generated Asterisk config, so keep it strictly conservative.
if [ -z "$SERVER_ID" ]; then
  echo "register-node: --server-id is required" >&2
  exit 1
fi
# bash's [[ =~ ]], never `grep -Eq`: grep anchors ^ and $ to LINE boundaries, so a
# value containing a newline passes as soon as ANY line matches -- and SERVER_ID and
# SERVER_IP are interpolated into SQL literals below with no escaping at all, so the
# regex is their ONLY defence. [[ =~ ]] anchors to the whole string.
if ! [[ "$SERVER_ID" =~ ^[A-Za-z0-9_-]{1,10}$ ]]; then
  echo "register-node: --server-id must be 1-10 chars of [A-Za-z0-9_-]" >&2
  exit 1
fi
if ! [[ "$SERVER_IP" =~ ^((0|[1-9][0-9]{0,2})\.){3}(0|[1-9][0-9]{0,2})$ ]]; then
  # A leading-zero octet (e.g. '001') matches the older, looser shape below
  # but not this one -- call it out specifically. It's the "looks like it
  # worked" failure: MariaDB stores it as the literal string '001' in
  # servers.server_ip, which never matches a real connection from '1', so the
  # node registers, looks healthy, and never actually gets used.
  if [[ "$SERVER_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "register-node: '--server-ip=${SERVER_IP}' has a leading-zero octet." >&2
    echo "MariaDB would store that as the literal string, e.g. '001', which never matches a real connection from '1'. Write each octet without leading zeros." >&2
  else
    echo "register-node: '--server-ip=${SERVER_IP}' is not a plain IPv4 address." >&2
    echo "Set LOCAL_IP in .env, or pass --server-ip explicitly." >&2
  fi
  exit 1
fi

# Reject 999.1.1.1 and friends: MariaDB would happily store an unusable
# address in servers.server_ip. Mirrors grant-dialer.sh's check.
OLDIFS=$IFS; IFS=.
for octet in $SERVER_IP; do
  if [ "$octet" -gt 255 ] 2>/dev/null; then
    IFS=$OLDIFS
    echo "register-node: '--server-ip=${SERVER_IP}' has an octet above 255." >&2
    exit 1
  fi
done
IFS=$OLDIFS

[ -n "$DESCRIPTION" ] || DESCRIPTION="Dialer ${SERVER_ID}"
# Escape the description for a single-quoted SQL literal. TWO metacharacters
# matter, not one: MariaDB runs without NO_BACKSLASH_ESCAPES by default (checked
# @@sql_mode on this stack), so a backslash is live inside string literals. A
# description merely ENDING in one -- a Windows path, say -- would escape the
# closing quote and produce ERROR 1064. Backslashes first, then quotes; doing it
# in the other order would re-escape the backslashes this step introduces.
ESC_DESC=$(printf '%s' "$DESCRIPTION" | sed -e 's/\\/\\\\/g' -e "s/'/''/g")

DBNAME=$(sed -n 's/^VARDB_database *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBUSER=$(sed -n 's/^VARDB_user *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBPASS=$(sed -n 's/^VARDB_pass *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')
DBHOST="${DBHOST:-$(sed -n 's/^VARDB_server *=> *//p' /etc/astguiclient.conf | tr -d ' \r\t')}"

# --skip-ssl for the same reason as entrypoint.sh: the trixie MariaDB 11.x
# client requires TLS by default while the 10.11 server offers none.
MYSQL_OPTS="--skip-ssl"
q() { mysql $MYSQL_OPTS -h "$DBHOST" -u"$DBUSER" -p"$DBPASS" "$DBNAME" -N -B -e "$1"; }

# --- refuse to overwrite ---------------------------------------------------
# Re-running must be safe. Both checks matter: a duplicate server_id would
# collide with the UNIQUE key, and a duplicate server_ip would give two rows the
# entrypoint cannot tell apart, which is precisely the ambiguity VICI_SERVER_ID
# exists to resolve.
# Assign FIRST, then test -- never `if [ -n "$(q ...)" ]`. A command substitution
# inside an `if` condition is exempt from set -e, so a query that FAILS (dropped
# connection, lock timeout) returns empty and reads as "no duplicate", letting the
# script INSERT anyway. As a plain assignment, a failed query aborts the script.
# That matters most for server_ip, which has no UNIQUE key to catch it afterwards
# (server_id does), so a defeated check there creates exactly the two-rows-one-IP
# state this logic exists to prevent.
EXISTING_BY_ID=$(q "SELECT server_id FROM servers WHERE server_id='${SERVER_ID}';")
if [ -n "$EXISTING_BY_ID" ]; then
  echo "register-node: server_id '${SERVER_ID}' already exists. Refusing to overwrite." >&2
  exit 1
fi

EXISTING_BY_IP=$(q "SELECT server_id FROM servers WHERE server_ip='${SERVER_IP}';")
if [ -n "$EXISTING_BY_IP" ]; then
  echo "register-node: ${SERVER_IP} is already registered as '${EXISTING_BY_IP}'." >&2
  echo "Two rows sharing an IP cannot be told apart. Refusing." >&2
  exit 1
fi

# --- pick a template -------------------------------------------------------
# The server with the most conference rows: on a fresh install that is the seed,
# and on a grown install it is a fully provisioned node. Either is a correct
# source for the extension list.
TEMPLATE=$(q "SELECT server_ip FROM conferences GROUP BY server_ip ORDER BY COUNT(*) DESC LIMIT 1;")
if [ -z "$TEMPLATE" ]; then
  echo "register-node: no server in this database has conference rows, so there" >&2
  echo "is nothing to copy an extension list from. Registering would create a" >&2
  echo "server that cannot hold a conference, so this is a hard failure." >&2
  echo "Fix: restore the seed, or add conferences in Admin -> Conferences." >&2
  exit 1
fi
echo "[register-node] copying conference extensions from ${TEMPLATE}"

# --- create the node -------------------------------------------------------
# conf_engine is forced to CONFBRIDGE, not copied: this image compiles
# ConfBridge only (app_meetme is not built), and the column defaults to MEETME.
# Everything else is inherited from the template so a new node matches the
# install's existing conventions.
q "INSERT INTO servers
     (server_id, server_description, server_ip, active, asterisk_version,
      conf_engine, conf_secret, local_gmt, user_group)
   SELECT '${SERVER_ID}', '${ESC_DESC}', '${SERVER_IP}', 'Y', asterisk_version,
          'CONFBRIDGE', conf_secret, local_gmt, user_group
     FROM servers WHERE server_ip='${TEMPLATE}';"

# server_updater is a MEMORY table: its rows do not survive a database
# restart, so this insert is best-effort -- VICIdial's own keepalive
# (ADMIN_keepalive_ALL.pl) repopulates it. A missing row here after a DB
# restart is expected, not corruption.
q "INSERT INTO server_updater (server_ip, last_update)
   VALUES ('${SERVER_IP}', NOW());"

q "INSERT INTO conferences (conf_exten, server_ip, extension)
   SELECT conf_exten, '${SERVER_IP}', extension
     FROM conferences WHERE server_ip='${TEMPLATE}';"

# leave_3way is reset to its default rather than copied: it is live call state,
# not configuration, and inheriting it would fabricate history for a new node.
q "INSERT INTO vicidial_conferences (conf_exten, server_ip, extension, leave_3way)
   SELECT conf_exten, '${SERVER_IP}', extension, '0'
     FROM vicidial_conferences WHERE server_ip='${TEMPLATE}';"

CONF_N=$(q "SELECT COUNT(*) FROM conferences WHERE server_ip='${SERVER_IP}';")
VCONF_N=$(q "SELECT COUNT(*) FROM vicidial_conferences WHERE server_ip='${SERVER_IP}';")

echo "[register-node] registered ${SERVER_ID} @ ${SERVER_IP}"
echo "[register-node]   conferences=${CONF_N} vicidial_conferences=${VCONF_N}"
echo
echo "[register-node] Set this on the node, or it cannot identify its own row:"
echo "[register-node]   VICI_SERVER_ID=${SERVER_ID}"
