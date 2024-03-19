#!/usr/bin/env raku

my @config;
my @config-optional;

if !@*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Uses an internal array of configuration
    options to feed Apache's 'configure'.

    HERE
}

BEGIN {
    @config =
    ""
    ;
    @config-optional =
    ""
    ;

}
