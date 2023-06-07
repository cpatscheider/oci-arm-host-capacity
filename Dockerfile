from debian:stable

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
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
    ; \
    rm -rf /var/lib/apt/lists/*; \
    curl -sk https://getcomposer.org/installer -o composer-setup.php; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    mkdir /app
    
COPY ./* /app/

WORKDIR /app
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer update; \
    composer install
   
