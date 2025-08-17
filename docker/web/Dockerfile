# Last known compatible version - 07/07/25
FROM ubuntu:22.04 AS final

ARG VICI_DB
ARG VICI_HOST
ARG VICI_EXT_IP
ARG VICI_WEB_HOST
ENV DEBIAN_FRONTEND=noninteractive

## Set time on server - UTC, America/New_York, etc...
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo postfix postfix/main_mailer_type string 'No configuration' | debconf-set-selections

## Install package pre-reqs
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    software-properties-common \
    ca-certificates \
    wget \
    curl \
    cron \
    unzip \
    zip \
    ntpdate \
    build-essential \
    libcurl4-openssl-dev \
    libzip-dev \
    libssl-dev \
    libjansson-dev \
    iftop \
    libxml2-dev \
    vim \
    lsb-release \
    gnupg \
    ntp \
    screen \
    libncurses5-dev \
    libploticus0-dev \
    libsqlite3-dev \
    subversion \
    subversion-tools \
    supervisor \
    # MariaDB client
    mariadb-client* \
    libmysqlclient-dev \
    # Perl packages
    libmysql-diff-perl \
    libnet-daemon-perl \
    libwww-curl-perl \
    libdbd-mysql \
    libdbd-mysql-perl \
    libdbi-perl \
    libnet-telnet-perl \
    libnet-server-perl \
    libunicode-map8-perl \
    libjcode-perl \
    libspreadsheet-writeexcel-perl \
    libole-storage-lite-perl \
    libspreadsheet-parseexcel-perl \
    libcurses-perl \
    libgetopt-simple-perl \
    libnet-domain-tld-perl \
    libmail-sendmail-perl \
    ## Asterisk Stuff
    dahdi \
    asterisk-dahdi \
    sipsak \
    ## Audio installs
    sox \
    libsox-fmt-all \
    lame \
    mpg123

## CPAN installs
RUN cpan -i CPAN::Meta::Requirements \
    Digest::MD5 \
    Digest::SHA1 \
    CPAN && \
    cpan reload CPAN

RUN cpan force install Time::HiRes Switch



## PHP & Apache2 installs
RUN add-apt-repository -y   ppa:ondrej/php && apt-get update  && \
    apt-get install -y \
        libapache2-mod-php7.4 \
        apache2 \
        certbot \
        python3-certbot-apache \
        php7.4 \
        php7.4-cli \
        php7.4-common \
        php7.4-json \
        php7.4-mysql \
        php7.4-readline \
        php7.4-mysqli \
        php7.4-dev \
        php7.4-curl \
        php7.4-xml \
        php7.4-mbstring
## Vicidial code downlaod
RUN mkdir -p /usr/src/astguiclient && \
    cd /usr/src/astguiclient && \
    svn checkout svn://svn.eflo.net/agc_2-X/trunk && \
    cd trunk



## Separate installs for "web-only" service and dialer
RUN cd /usr/src/astguiclient/trunk && perl install.pl \
        --no-prompt \
        --server_ip=${VICI_HOST} \
        --web=/var/www/html \
        --DB_server=${VICI_DB} \
        --web-only

## Copy vicidial custom supervisor, apache2, & vicidial conf files into the container
COPY supervisord.conf /etc/supervisor/conf.d/
RUN chmod +x /usr/share/astguiclient/*.pl
COPY ./apache2/html/* /var/www/html/
COPY --chmod=0666 ./asterisk-conf/* /etc/asterisk/


## For running SSL - certbot container must get certs prior
# COPY ./apache2/conf/*.conf /etc/apache2/sites-available
# RUN a2enmod ssl && a2ensite default-ssl

EXPOSE 80 443


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
