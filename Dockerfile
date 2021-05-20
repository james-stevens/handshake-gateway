# (c) Copyright 2019-2020, James Stevens ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine:3.13

RUN apk update
RUN apk upgrade

RUN apk add bind
RUN apk add nginx
RUN apk add php8 php8-fpm php8-session php8-curl php8-xml php8-simplexml php8-ctype
RUN apk add squid squid-lang-uk

RUN apk add python3
RUN apk add py-pip
RUN apk add nginx

RUN pip install --upgrade pip
RUN pip install gunicorn
RUN pip install Flask
RUN pip install dnspython

RUN mkdir -p /usr/local/dns
COPY *.py /usr/local/dns/
RUN python3 -m compileall /usr/local/dns/
COPY start_wsgi /usr/local/bin/

RUN mkdir -p /opt /opt/named /opt/named/dev /opt/named/etc
RUN mkdir -p /opt/named/etc/bind /opt/named/zones /opt/named/var /opt/named/var/run

RUN cp -a /etc/bind/rndc.key /opt/named/etc/bind

RUN chown -R named: /opt/named/zones /opt/named/var
RUN rm -f /etc/periodic/monthly/dns-root-hints

COPY named.conf /opt/named/etc/bind
COPY servers.inc /opt/named/etc/bind
COPY update_servers /etc/periodic/weekly

COPY start_syslogd /usr/local/bin
COPY start_bind /usr/local/bin

COPY www.conf /etc/php8/php-fpm.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN cd /tmp ; wget https://github.com/james-stevens/glype/archive/refs/tags/v1.0.tar.gz

RUN cd /opt ; tar xf /tmp/v1.0.tar.gz
RUN ln -s /opt/glype-1.0 /opt/htdocs
RUN rm -f /tmp/v1.0.tar.gz

RUN mkdir -p /opt/pems
COPY certkey.pem /opt/pems

COPY squid.conf /etc/squid/squid.conf

COPY inittab /etc/inittab
CMD [ "/sbin/init" ]
