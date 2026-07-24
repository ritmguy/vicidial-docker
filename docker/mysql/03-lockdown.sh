#!/bin/bash
# Replace the wildcard accounts with explicit loopback ones, once the schema has
# loaded.
#
# Two accounts valid from ANY host exist by the time this runs:
#
#   cron@'%'  created by the mariadb entrypoint from MYSQL_USER. It cannot simply
#             be skipped: VICIdial's schema (MySQL_AST_CREATE_tables.sql) issues
#             GRANTs to both cron@'%' and cron@localhost, and a GRANT to a
#             missing user fails with ERROR 1133, which aborts the rest of the
#             schema load. So it must exist during the load and go afterwards.
#
#   root@'%'  created by the mariadb entrypoint, because MARIADB_ROOT_HOST
#             defaults to '%'.
#
# IMPORTANT: cron@localhost is NOT sufficient on its own. In MariaDB, a grant for
# host 'localhost' matches unix-socket connections; a TCP connection to 127.0.0.1
# matches host '127.0.0.1'. VICIdial connects over TCP to 127.0.0.1, so it was
# in fact relying on cron@'%'. Dropping the wildcard without adding an explicit
# loopback account breaks every service with ERROR 1045.
#
# So: add cron@127.0.0.1 (and the IPv6 loopback), then remove the wildcards.
# Nothing needs network-reachable credentials while all roles share one host.
#
# This runs only on a FRESH database volume, like every init script. An existing
# installation keeps its wildcard accounts -- the upgrade notes give the one-off
# command to remove them. bind-address in my.cnf.mariadb is what protects
# existing installs, and it takes effect on restart.
set -e
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
CREATE USER IF NOT EXISTS 'cron'@'127.0.0.1' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'cron'@'127.0.0.1';
CREATE USER IF NOT EXISTS 'cron'@'::1' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'cron'@'::1';
DROP USER IF EXISTS 'cron'@'%';
DROP USER IF EXISTS 'root'@'%';
FLUSH PRIVILEGES;
SQL
echo "[03-lockdown] added cron@127.0.0.1 and cron@::1; dropped cron@'%' and root@'%'"
