FROM alpine:3.17.3

ENV LARAVEL_USER  1000
ENV LOG_FORMAT    main

RUN apk add --no-cache \
  ca-certificates \
  composer \
  nginx \
  php81 \
  php81-curl \
  php81-dom \
  php81-fileinfo \
  php81-fpm \
  php81-iconv \
  php81-json \
  php81-mbstring \
  php81-openssl \
  php81-phar \
  php81-session \
  php81-tokenizer \
  php81-xml \
  php81-xmlwriter \
  php81-zip \
  shadow

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

COPY ./ng-default.conf /etc/nginx/http.d/default.conf

RUN pass=$( N=16 ; cat /dev/urandom | tr -dc A-Za-z0-9 | head -c$N ); \
  printf "%s\n%s\n" $pass $pass | adduser laravel

WORKDIR /srv

EXPOSE 80

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;" ]
