from debian:stable

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        php \
        php-common \
        php-cli \
        curl \
        php-mbstring \
        git \
        unzip  \
    ; \
    rm -rf /var/lib/apt/lists/* \
    curl -sS https://getcomposer.org/installer -o composer-setup.php \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    mkdir /app
    
COPY ./* /app/

WORKDIR /app

RUN composer install
   
