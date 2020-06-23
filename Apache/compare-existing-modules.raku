#!/usr/bin/env raku

use Text::Utils :strip-comment;

if !@*ARGS {
    say qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <modfile1> <modfile2> [debug]

    This program compares the two Apache 'LoadModule' configuration
    files and shows differences to STDOUT.
    HERE
    exit;
}

my $debug  = 0;
my $if1 = '';
my $if2 = '';
for @*ARGS {
    when /^d/ { $debug = 1 }
    default {
        if !$if1 {
        }
        elsif !$if2 {
        }
        else {
            note "FATAL: Unknown arg '$_'";
            exit;
        }
    }
}

say "Comparing files '$if1' and '$if2'...";
my (%m1, %m2);

sub read-module-file($fnam, %h, :$debug) {
    for $fnam.IO.lines {

    }
}
