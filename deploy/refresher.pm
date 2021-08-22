#!/usr/bin/env perl

package refresher;

use warnings;
use strict;
use 5.010;
use Digest::SHA qw(hmac_sha256_hex);

sub git_repo_update {
    my ($wiki_repo, $remote, $ssh_key) = @_;
    git_repo_initial_clone($wiki_repo, $remote, $ssh_key) unless -e "$wiki_repo/.git";

    chdir($wiki_repo);
    system('git', 'fetch', '--all');
    system('git', 'reset', '--hard', 'origin/main');
}

sub git_repo_initial_clone {
    my ($wiki_repo, $remote, $ssh_key) = @_;
    say "No repo was found. Performing initial clone.";

    my $ssh_command = "ssh -i $ssh_key -o StrictHostKeyChecking=accept-new";
    system('git', 'clone', $remote, $wiki_repo, '--config', "core.sshCommand=$ssh_command", '--config', 'ssh.variant=ssh');

    chdir($wiki_repo);
    system('ln', '-sTf', '/monotome/monotome');
    system('ln', '-sTf', '/monotome/index.html');
}

sub update_index_json {
    my $wiki_repo = shift;
    chdir($wiki_repo);
    system('node', 'monotome/bin/generate.js');
}

sub verify_request {
    # check that the request is a legitimate webhook from gitea, otherwise die
    my ($key, $payload, $header_hmac) = @_;

    my $actual_hmac = hmac_sha256_hex($payload, $key);
    die "Mismatching webhook headers, header $header_hmac actual $actual_hmac body $payload" unless $header_hmac eq $actual_hmac;
}

1;
