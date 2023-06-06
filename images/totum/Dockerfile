ARG UBUNTU_VERSION="focal"
FROM ubuntu:${UBUNTU_VERSION}
ARG DEBIAN_FRONTEND=noninteractive
# ARG GIT_AUTH='...'
# ARG TOTUM_REPO="https://${GIT_AUTH}github.com/totumonline/totum-pro.git"
ARG TOTUM_REPO="https://github.com/totumonline/totum-mit.git"
ENV TZ=Etc/UTC

ENV TOTUM_DB_HOST=127.0.0.1
ENV TOTUM_DB_PORT=5432
ENV TOTUM_DB_USER=
ENV TOTUM_DB_PASSWORD=
ENV TOTUM_DB_NAME=
ENV TOTUM_DB_SCHEME=

ENV TOTUM_LANG=ru
ENV TOTUM_INST=multi
ENV TOTUM_USER=
ENV TOTUM_PASSWORD=
ENV TOTUM_MAIL=
ENV TOTUM_HOST=

ENV SMTP_SERVER=
ENV SMTP_LOGIN=
ENV SMTP_PASSWORD=

ENV BUILD_DEPS \
    software-properties-common \
    cron \
    unzip \
    curl \
    git \
    nano \
    nginx \
    supervisor

ENV PHP_DEPS \
    php8.0 \
    php8.0-bcmath \
    php8.0-cli \
    php8.0-curl \
    php8.0-fpm \
    php8.0-gd \
    php8.0-mbstring \
    php8.0-opcache \
    php8.0-pgsql \
    php8.0-xml \
    php8.0-zip \
    php8.0-soap \
    php8.0-ldap

RUN apt-get -q update \
 && apt-get install -qy --no-install-recommends \
    apt-utils \
    locales \
    tzdata \
 && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8 \
 && apt-get install -qy --no-install-recommends \
    software-properties-common \
 && add-apt-repository ppa:ondrej/php \
 && apt-get -q update \ 
 && apt-get install -qy --no-install-recommends \
    $BUILD_DEPS \
    $PHP_DEPS \
 && cp /usr/lib/php/8.0/php.ini-production /etc/php/8.0/fpm/php.ini \
 && adduser --disabled-password --gecos '' --shell /bin/bash totum \
 && apt-get autoremove \
 && apt-get autoclean \
 && rm -rf /var/lib/apt/lists \
 && rm -rf /etc/php/8.0/fpm/pool.d/* \
 && mkdir -p /run/php \
 && mkdir -p /var/lib/php/sessions_totum \
 && chmod 1733 /var/lib/php/sessions_totum

USER totum:totum

WORKDIR /home/totum
RUN git clone ${TOTUM_REPO} totum
WORKDIR /home/totum/totum
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --quiet \
 && rm composer-setup.php \
 && php composer.phar install --no-dev \
 && touch Conf.php

USER root:root

COPY ["./conf/totum-php.conf", "/etc/php/8.0/fpm/pool.d/totum.conf"]
COPY ["./conf/totum-nginx.conf", "/etc/nginx/sites-available/default"]
COPY ["./conf/totum.cronjob", "/etc/cron.d/totum"]
COPY ["./conf/supervisord.conf", "/etc/supervisor/conf.d/totum.conf"]
COPY ["./conf/fls/", "/home/totum/totum/http/fls/"]
COPY ["./conf/entrypoint.sh", "/entrypoint.sh"]

RUN ln -s /home/totum/totum/bin/totum /bin/totum \
 && chown totum:totum -R /home/totum/totum \
 && chmod 0644 /etc/cron.d/totum \
 && crontab /etc/cron.d/totum \
 && chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=10s CMD curl -f http://127.0.0.1:9001/ || exit 1

# CMD ["sleep", "infinity"]