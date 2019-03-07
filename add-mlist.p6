#!/usr/bin/env perl6

use lib '.';
use MySympa;

if !@*ARGS {
    say qq:to/HERE/;
    Usage:  $*PROGRAM go | show [debug]

    Creates the files for the domains and mailing
    lists for those defined in module 'MySympa'.

    Enter 'show' to list the known domains and lists.
    HERE

    exit;
}

my $cmd   = 0;
my $debug = 0;
for @*ARGS {
    when /:i ^g / {
        $cmd = 1;
        gen-files :$debug;
    }
    when /:i ^s / {
        $cmd = 2;
        show :$debug;
    }
    when /:i ^d / {
        $debug = 1;
    }
    default {
        say "WARNING: Unknown arg '$_'...ignoring.";
    }
}

if !$cmd {
    say "FAILURE: No known command entered.";
    exit;
}

my @ofils;


##### SUBROUTINES ##### 
sub gen-files(:$debug) {
}

sub show(:$debug) {
    for %dom-lists.keys.sort -> $dom {
        say "  domain: $dom";
        my %lists = %dom-lists{$dom};
        for %lists.keys.sort -> $list {
            my $typ = %lists{$list};
            say "    list: $list";
            say "      type: $typ";
        } 
    }
}

