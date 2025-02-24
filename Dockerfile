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
    ; \
    rm -rf /var/lib/apt/lists/*; \
    curl -sS https://getcomposer.org/installer -o composer-setup.php; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    mkdir /app; \
    mkdir -p /var/spool/cron/crontabs; \
    touch /var/log/oci.log; \
    touch /var/log/cron.log; \
    chmod 777 /var/log/oci.log; \
    chmod 777 /var/log/cron.log; \
    echo '* * * * * /usr/bin/php /app/index.php >> /var/log/oci.log' > /var/spool/cron/crontabs/root
    
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
   
