#!/bin/bash
# VICIdial's schema (MySQL_AST_CREATE_tables.sql) grants to BOTH cron@'%' and
# cron@localhost, but the mariadb entrypoint only creates cron@'%' (from
# MYSQL_USER). The cron@localhost GRANT then fails with ERROR 1133, which aborts
# the rest of the schema load — dropping the admin user, the server row, and
# more. Create cron@localhost first so the schema loads to completion.
set -e
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
CREATE USER IF NOT EXISTS 'cron'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'cron'@'localhost';
FLUSH PRIVILEGES;
SQL
