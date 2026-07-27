#!/bin/bash
# Grant one remote dialer access to this database.
#
# Init scripts in /docker-entrypoint-initdb.d/ run ONLY on a fresh data
# directory, so they cannot help an operator adding a dialer to a database that
# already exists. This is the supported path for that, run against a LIVE
# container:
#
#     docker-compose exec db grant-dialer 192.0.2.11
#
# MariaDB matches grants by CONNECTING HOST. A 'localhost' grant covers
# unix-socket connections only, so a dialer connecting over TCP needs an account
# for its own address specifically -- the same reasoning as 03-lockdown.sh.
#
# Credentials come from the container's own environment (mysql.env), so nothing
# secret is typed on the command line where it would land in shell history.
set -eu

IP="${1:-}"

if [ -z "$IP" ]; then
  echo "usage: grant-dialer <dialer-ip>" >&2
  echo "  e.g. docker-compose exec db grant-dialer 192.0.2.11" >&2
  exit 1
fi

# Refuse wildcards and anything that is not a plain IPv4 address.
#
# cron@'%' is exactly the account 03-lockdown.sh removed in v0.3.0. With
# network_mode: host the database is reachable on every interface its host has,
# and cron's password is VICIdial's baked-in default -- so a wildcard grant
# hands the database to anything that can route to it. Grant one address at a
# time, deliberately.
#
# bash's [[ =~ ]] rather than `grep -Eq`: grep anchors ^ and $ to LINE
# boundaries, so an argument containing a newline passes validation as soon as
# ANY line matches -- and the rest of the value then breaks out of the '${IP}'
# SQL literal below. [[ =~ ]] anchors to the whole string, which is what this
# check has to mean.
if ! [[ "$IP" =~ ^((0|[1-9][0-9]{0,2})\.){3}(0|[1-9][0-9]{0,2})$ ]]; then
  # A leading-zero octet (e.g. '001') matches the older, looser shape below
  # but not this one -- call it out specifically. It's the "looks like it
  # worked" failure: MariaDB stores it as the literal string '001', which
  # never matches a real connection from '1', so the grant silently does
  # nothing and the dialer still gets ERROR 1130.
  if [[ "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "grant-dialer: '${IP}' has a leading-zero octet." >&2
    echo "MariaDB would store that as the literal string, e.g. '001', which never matches a real connection from '1'. Write each octet without leading zeros." >&2
  else
    echo "grant-dialer: '${IP}' is not a plain IPv4 address." >&2
    echo "Wildcards such as '%' are refused on purpose -- grant each dialer's address." >&2
  fi
  exit 1
fi

# Reject 999.1.1.1 and friends: MariaDB would happily store an unusable account.
OLDIFS=$IFS; IFS=.
for octet in $IP; do
  if [ "$octet" -gt 255 ] 2>/dev/null; then
    IFS=$OLDIFS
    echo "grant-dialer: '${IP}' has an octet above 255." >&2
    exit 1
  fi
done
IFS=$OLDIFS

# Escape for single-quoted SQL literals. TWO metacharacters matter, not one:
# MariaDB runs without NO_BACKSLASH_ESCAPES by default (checked @@sql_mode on
# this stack, same as register-node.sh), so backslash is live inside string
# literals too. A cron password containing a quote, or ending in a backslash,
# would otherwise break out of the literal and produce ERROR 1064.
# Backslashes first, then quotes -- doing it in the other order would
# re-escape the backslashes this step introduces.
ESC_USER=$(printf '%s' "$MYSQL_USER" | sed -e 's/\\/\\\\/g' -e "s/'/''/g")
ESC_PASS=$(printf '%s' "$MYSQL_PASSWORD" | sed -e 's/\\/\\\\/g' -e "s/'/''/g")

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
CREATE USER IF NOT EXISTS '${ESC_USER}'@'${IP}' IDENTIFIED BY '${ESC_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${ESC_USER}'@'${IP}';
FLUSH PRIVILEGES;
SQL

echo "[grant-dialer] granted ${MYSQL_USER}@${IP}"
echo "[grant-dialer] NOTE: the dialer also needs this host's LAN address in"
echo "[grant-dialer] VICI_DB_BIND, and 3306 open to ${IP} in the firewall."
