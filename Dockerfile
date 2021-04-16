FROM alpine:latest
ARG BLUDIT_VERSION=3-13-1

LABEL maintainer="Werner Fleck <bludit@flexoft.net>"
LABEL name="deburau/bludit"

RUN addgroup -g 555 -S nginx \
    && adduser -SD -u 555 -h /usr/share/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apk --no-cache add curl \
         ruby \
         ruby-json \
         jq \
         nginx \
         php7 \
         php7-fpm \
         php7-curl \
         php7-dom \
         php7-gd \
         php7-json \
         php7-mbstring \
         php7-openssl \
         php7-session \
    && mkdir -p /usr/share/nginx/html

ADD https://www.bludit.com/releases/bludit-${BLUDIT_VERSION}.zip /bludit.zip
RUN rm -rf /etc/nginx/conf.d && mkdir /etc/nginx/conf.d

COPY root/ /

WORKDIR /usr/share/nginx/html

EXPOSE 8080
VOLUME ["/usr/share/nginx/html"]

ENTRYPOINT ["/docker-init.sh"]
