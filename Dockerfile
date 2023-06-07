from debian:stable

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        php \
        php-common \
        php-cli \
        php-curl \
        php-dom \
        curl \
        php-mbstring \
        git \
        unzip \ 
        curl \
        busybox-static \
        supervisor \
        python3-pip  \
        python3-setuptools \
        python3-wheel \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    curl -sS https://getcomposer.org/installer -o composer-setup.php; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    mkdir /app; \
    mkdir -p /var/spool/cron/crontabs; \
    echo '* * * * * /usr/bin/php /app/index.php' > /var/spool/cron/crontabs/ociarmhost; \
    pip install supervisor-stdout
    
# Copy local files
COPY cron.sh /
COPY supervisord.conf /

RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \
;
    
COPY ./* /app/
COPY ./src /app/src

WORKDIR /app
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer update; \
    composer install
    

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
   
