#!/bin/sh

export PERL5LIB="/etc/nginx/perl/lib"

su -m -s /usr/bin/perl nginx /etc/nginx/perl/lib/refresher_cli.pl
