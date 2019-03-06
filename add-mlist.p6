#!/usr/bin/env perl6

if !@*ARGS {
    say qq:to/HERE/;
    Usage:  $*PROGRAM <domain.tld>

    Adds the new domain to the known
    domains for the Sympa mailer.
    HERE

    exit;
}

