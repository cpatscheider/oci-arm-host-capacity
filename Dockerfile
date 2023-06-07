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
    mkdir /app
    
COPY ./* /app

WORKDIR /app

RUN composer install
   
