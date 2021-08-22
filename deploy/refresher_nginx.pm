#!/usr/bin/env perl

package refresher_nginx;

use nginx;
use warnings;
use strict;
use 5.010;
use refresher;

sub handler {
    my $request = shift;

    die "wiki_repo nginx var not set!" if $request->variable('wiki_repo') eq '';
    die "wiki_repo_remote nginx var not set!" if $request->variable('wiki_repo_remote') eq '';
    die "wiki_ssh_key nginx var not set!" if $request->variable('wiki_ssh_key') eq '';
    die "gitea_webhook_secret nginx var not set!" if $request->variable('gitea_webhook_secret') eq '';

    if ($request->has_request_body(\&handle_post)) {
        return OK;
    }

    return HTTP_BAD_REQUEST;
}

sub handle_post {
    my $request = shift;

    my $key = $request->variable('gitea_webhook_secret');
    my $payload = $request->request_body;
    my $header_hmac = $request->header_in('X-Gitea-Signature');
    refresher::verify_request($key, $payload, $header_hmac);

    my $wiki_repo = request->variable('wiki_repo');
    my $remote = $request->variable('wiki_repo_remote');
    my $ssh_key = $request->variable('wiki_ssh_key');
    refresher::git_repo_update($wiki_repo, $remote, $ssh_key);
    refresher::update_index_json($wiki_repo);

    return OK;
}

1;
