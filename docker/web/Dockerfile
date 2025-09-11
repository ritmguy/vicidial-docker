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
    libtime-hires-perl \
    libswitch-perl \
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



## PHP & Apache2 installs
RUN add-apt-repository -y   ppa:ondrej/php && apt-get update  && \
    apt-get install -y \
        libapache2-mod-php8.4 \
        apache2 \
        certbot \
        python3-certbot-apache \
        php8.4 \
        php8.4-cli \
        php8.4-common \
        php8.4-mysql \
        php8.4-readline \
        php8.4-mysqli \
        php8.4-dev \
        php8.4-curl \
        php8.4-xml \
        php8.4-mbstring
## Vicidial code downlaod
RUN mkdir -p /usr/share/astguiclient && \
    cd /usr/share/astguiclient && \
    svn checkout svn://svn.eflo.net/agc_2-X/trunk 

## Separate installs for "web-only" service and dialer
RUN cd /usr/share/astguiclient/trunk && perl install.pl \
        --no-prompt \
        --server_ip=${VICI_HOST} \
        --web=/var/www/html \
        --DB_server=${VICI_DB} \
        --web-only

## Copy vicidial custom supervisor, apache2, & vicidial conf files into the container
COPY supervisord.conf /etc/supervisor/conf.d/
RUN chmod +x /usr/share/astguiclient/trunk/*.pl
COPY ./html/* /var/www/html/


## For running SSL - certbot container must get certs prior
# COPY ./apache2/conf/*.conf /etc/apache2/sites-available
# RUN a2enmod ssl && a2ensite default-ssl

EXPOSE 80 443


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
