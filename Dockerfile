FROM nginx:stable-alpine-perl

RUN apk add --no-cache git nodejs openssh
RUN mkdir /wikirepo
RUN chown nginx:nginx /wikirepo

COPY --chown=nginx:nginx index.html /monotome/index.html
COPY --chown=nginx:nginx monotome /monotome/monotome/

COPY deploy/nginx.conf /etc/nginx/nginx.conf
COPY deploy/default.conf.template /etc/nginx/templates/default.conf.template
COPY deploy/refresher.pm /etc/nginx/perl/lib/refresher.pm
COPY deploy/refresher_cli.pl /etc/nginx/perl/lib/refresher_cli.pl
COPY deploy/refresher_nginx.pm /etc/nginx/perl/lib/refresher_nginx.pm
COPY deploy/populator.sh /docker-entrypoint.d/populator.sh
