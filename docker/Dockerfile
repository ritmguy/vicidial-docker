# syntax=docker/dockerfile:1
# Unified multi-stage build: shared `base` -> `dialer` / `web` targets.
# Base: Debian trixie (pinned by digest) + vanilla Asterisk 20 + native PHP 8.4.
ARG BASE_IMAGE=debian:trixie-slim@sha256:020c0d20b9880058cbe785a9db107156c3c75c2ac944a6aa7ab59f2add76a7bd
ARG VICI_REV=4005
ARG ASTERISK_VER=20.20.1
ARG ASTERISK_URL=https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20.20.1.tar.gz
# SHA256 verified against Asterisk Dev Team GPG signature (key F2FC93DB...37191CE7)
ARG ASTERISK_SHA256=32ef7db8e449629128eb5f7e42d3d704f03daacb91d76ee694a9acf7f1fd53e2

# ---------------- shared base ----------------
FROM ${BASE_IMAGE} AS base
ARG VICI_REV
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo postfix postfix/main_mailer_type string 'No configuration' | debconf-set-selections

# System + Perl + audio deps (certbot / ntp / dahdi removed vs. the old images;
# dahdi headers are added in the dialer stage in Task 4).
RUN apt-get update -y && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates wget curl cron unzip zip build-essential \
    libcurl4-openssl-dev libzip-dev libssl-dev libjansson-dev iftop libxml2-dev vim \
    lsb-release gnupg screen libncurses-dev libploticus0-dev libsqlite3-dev \
    subversion subversion-tools supervisor mariadb-client* default-libmysqlclient-dev \
    libmysql-diff-perl libnet-daemon-perl libwww-curl-perl libdbd-mysql-perl \
    libdbi-perl libnet-telnet-perl libnet-server-perl libunicode-map8-perl \
    libspreadsheet-writeexcel-perl libole-storage-lite-perl libspreadsheet-parseexcel-perl \
    libcurses-perl libgetopt-simple-perl libnet-domain-tld-perl libmail-sendmail-perl \
    libswitch-perl sipsak sox libsox-fmt-all lame mpg123 \
 && rm -rf /var/lib/apt/lists/*

RUN cpan -i CPAN::Meta::Requirements Digest::MD5 Digest::SHA1 CPAN && cpan reload CPAN

# PHP 8.4 + Apache — native from Debian trixie main (no PPA; php-* metapackages = 8.4).
# php-mysql provides the mysqli extension; Time::HiRes is core Perl on Debian.
RUN apt-get update -y && apt-get install -y \
    apache2 libapache2-mod-php php-cli php-common php-mysql \
    php-readline php-dev php-curl php-xml php-mbstring \
 && rm -rf /var/lib/apt/lists/*

# Single pinned VICIdial checkout, shared by both targets (kills the split-brain risk).
RUN mkdir -p /usr/share/astguiclient && cd /usr/share/astguiclient && \
    svn checkout -r ${VICI_REV} svn://svn.eflo.net/agc_2-X/trunk

# ---------------- dialer ----------------
FROM base AS dialer
ARG VICI_DB=127.0.0.1
ARG VICI_HOST
ARG ASTERISK_VER
ARG ASTERISK_URL
ARG ASTERISK_SHA256

COPY --chmod=0644 --chown=root:root dialer/crontab /etc/cron.d/vici_cron
RUN crontab /etc/cron.d/vici_cron

# Build vanilla Asterisk 20 from the GPG-verified, SHA256-pinned tarball.
# apt-get update first: the base stage cleared /var/lib/apt/lists, and
# Asterisk's install_prereq apt-installs its build deps.
# dahdi-source ships /usr/include/dahdi/user.h so ./configure detects DAHDI and
# res_timing_dahdi.so can be built (Task 4 timing). No kernel module is built here.
RUN apt-get update -y && apt-get install -y --no-install-recommends dahdi-source && cd /usr/src && \
    wget -O asterisk.tar.gz "${ASTERISK_URL}" && \
    echo "${ASTERISK_SHA256}  asterisk.tar.gz" | sha256sum -c - && \
    tar -xzf asterisk.tar.gz && cd asterisk-${ASTERISK_VER}/ && \
    ./contrib/scripts/install_prereq install && ./bootstrap.sh && \
    ./configure --libdir=/usr/local/lib --with-astmoddir=/var/lib --with-gsm=internal \
        --with-ssl --enable-asteriskssl --with-pjproject-bundled --with-jansson-bundled && \
    make menuselect/menuselect menuselect-tree menuselect.makeopts && \
    menuselect/menuselect --enable app_confbridge --enable res_srtp \
        --enable res_http_websocket --enable res_timing_dahdi menuselect.makeopts && \
    make -j"$(nproc)" && make install && make samples && \
    sed -i 's|noload = chan_sip.so|;noload = chan_sip.so|g' /etc/asterisk/modules.conf && \
    printf '\n; VICIdial ConfBridge profiles (auto-generated at runtime by ADMIN_keepalive_ALL.pl)\n#include confbridge-vicidial.conf\n' >> /etc/asterisk/confbridge.conf && \
    cd /usr/share/astguiclient/trunk && perl install.pl --no-prompt \
        --server_ip=${VICI_HOST} --without-web --DB_server=${VICI_DB} \
        --active_keepalives=1234568CS --khomp-enable

COPY dialer/supervisord.conf /etc/supervisor/conf.d/
COPY dialer/start_asterisk_boot.pl /usr/share/astguiclient/trunk/
COPY --chmod=0755 dialer/entrypoint.sh /entrypoint.sh
COPY --chmod=0755 dialer/register-node.sh /usr/local/bin/register-node
RUN chmod +x /usr/share/astguiclient/trunk/*.pl
COPY --chmod=0644 ./dialer/asterisk-conf/* /etc/asterisk/

EXPOSE 5060/tcp 5060/udp 10000-20000/udp 4569/udp 8089/tcp
ENTRYPOINT ["/entrypoint.sh"]

# ---------------- web ----------------
FROM base AS web
ARG VICI_DB=127.0.0.1
ARG VICI_HOST

RUN cd /usr/share/astguiclient/trunk && perl install.pl --no-prompt \
        --server_ip=${VICI_HOST} --web=/var/www/html --DB_server=${VICI_DB} --web-only

COPY web/supervisord.conf /etc/supervisor/conf.d/
RUN chmod +x /usr/share/astguiclient/trunk/*.pl
COPY web/html/* /var/www/html/

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# ---------------- db ----------------
# Schema comes straight from the pinned r4005 checkout in `base`, so the DB
# schema can never drift from the VICIdial code (root cause of the old 500s).
FROM mariadb:10.11.13-jammy AS db
COPY mysql/my.cnf.mariadb /etc/mysql/conf.d/my.cnf
RUN sed -i 's|socket *= */run/mysqld/mysqld.sock|socket = /tmp/mysql.sock|g' /etc/mysql/my.cnf
# 00- runs before the schema: create cron@localhost so the schema's GRANT to it
# doesn't abort the load (which was dropping the admin user + server rows).
COPY --chmod=0755 mysql/00-init-grants.sh /docker-entrypoint-initdb.d/00-init-grants.sh
COPY --from=base /usr/share/astguiclient/trunk/extras/MySQL_AST_CREATE_tables.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY --from=base /usr/share/astguiclient/trunk/extras/first_server_install.sql /docker-entrypoint-initdb.d/02-first-server.sql
# 03- runs last: drops the wildcard cron@'%' / root@'%' accounts the entrypoint
# and schema load require, once they are no longer needed.
COPY --chmod=0755 mysql/03-lockdown.sh /docker-entrypoint-initdb.d/03-lockdown.sh
# Operator command, NOT an init script: adding a dialer happens long after the
# data directory exists, and /docker-entrypoint-initdb.d/ only runs when it
# doesn't. On PATH so it is `docker-compose exec db grant-dialer <ip>`.
COPY --chmod=0755 mysql/grant-dialer.sh /usr/local/bin/grant-dialer
EXPOSE 3306
