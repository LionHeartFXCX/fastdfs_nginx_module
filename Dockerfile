FROM ubuntu

MAINTAINER LionHeart <LionHeart_fxc@163.com>

ENV NGINX_PATH=/nginx \
    NGINX_VERSION=1.8.1 \
    PCRE_VERSION=8.37 \
    ZLIB_VERSION=1.2.8 \
    OPENSSL_VERSION=1.0.2f 

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    git \
    make \
    wget

RUN mkdir -p ${NGINX_PATH}/nginx \
 && mkdir -p ${NGINX_PATH}/download \
 && mkdir -p ${NGINX_PATH}/nginx_module

RUN git clone https://github.com/happyfish100/libfastcommon.git ${NGINX_PATH}/nginx_module \
 && wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -P ${NGINX_PATH}/nginx \
 && wget "http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" -P ${NGINX_PATH}/download \
 && wget "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz" -P ${NGINX_PATH}/download \
 && wget "http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz" -P ${NGINX_PATH}/download \
 && tar zxvf ${NGINX_PATH}/nginx/nginx-${NGINX_VERSION}.tar.gz -C ${NGINX_PATH}/nginx \
 && tar zxvf ${NGINX_PATH}/download/openssl-${OPENSSL_VERSION}.tar.gz -C ${NGINX_PATH}/download \
 && tar zxvf ${NGINX_PATH}/download/pcre-${PCRE_VERSION}.tar.gz -C ${NGINX_PATH}/download \
 && tar zxvf ${NGINX_PATH}/download/zlib-${ZLIB_VERSION}.tar.gz -C ${NGINX_PATH}/download

WORKDIR ${NGINX_PATH}/nginx-${NGINX_VERSION}

RUN ./configure --with-pcre=${NGINX_PATH}/download/pcre-${PCRE_VERSION} \
                --with-zlib=${NGINX_PATH}/download/zlib-${ZLIB_VERSION} \
                --with-openssl=${NGINX_PATH}/download/openssl-${OPENSSL_VERSION} \
                --with-http_ssl_module \
                --add-module=${NGINX_PATH}/nginx_module/src \
 && make \
 && make install

EXPOSE 80
