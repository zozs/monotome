#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;
use refresher;

sub main {
    die "WIKI_REPO env var not set!" unless defined $ENV{'WIKI_REPO'};
    die "WIKI_REPO_REMOTE env var not set!" unless defined $ENV{'WIKI_REPO_REMOTE'};
    die "WIKI_SSH_KEY env var not set!" unless defined $ENV{'WIKI_SSH_KEY'};

    my $wiki_repo = $ENV{'WIKI_REPO'};
    my $remote = $ENV{'WIKI_REPO_REMOTE'};
    my $ssh_key = $ENV{'WIKI_SSH_KEY'};
    refresher::git_repo_update($wiki_repo, $remote, $ssh_key);
    refresher::update_index_json($wiki_repo);
}

main;
