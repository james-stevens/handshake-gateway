# (c) Copyright 2019-2020, James Stevens ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine:3.13

RUN apk update
RUN apk upgrade

RUN apk add bind
RUN apk add nginx
RUN apk add php8 php8-fpm php8-session php8-curl php8-xml php8-simplexml php8-ctype

RUN mkdir -p /opt /opt/named /opt/named/dev /opt/named/etc
RUN mkdir -p /opt/named/etc/bind /opt/named/zones /opt/named/var /opt/named/var/run

RUN cp -a /etc/bind/rndc.key /opt/named/etc/bind

RUN chown -R named: /opt/named/zones /opt/named/var
RUN rm -f /etc/periodic/monthly/dns-root-hints

COPY inittab /etc/inittab
COPY named.conf /opt/named/etc/bind
COPY servers.inc /opt/named/etc/bind
COPY update_servers /etc/periodic/weekly

COPY start_syslogd /usr/local/bin
COPY startup /usr/local/bin
COPY start_bind /usr/local/bin

COPY www.conf /etc/php8/php-fpm.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN cd /tmp ; wget https://github.com/james-stevens/glype/archive/refs/tags/v1.0.tar.gz

RUN cd /opt ; tar xf /tmp/v1.0.tar.gz
RUN ln -s /opt/glype-1.0 /opt/htdocs

RUN mkdir -p /opt/pems
COPY certkey.pem /opt/pems

CMD [ "/sbin/init" ]
