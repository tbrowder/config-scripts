#!/usr/bin/env raku

# the file collection that has been dowloaded:
my @fils = <
openssl-1.1.1g.tar.gz.sha256
openssl-1.1.1g.tar.gz

httpd-2.4.43.tar.gz
httpd-2.4.43.tar.gz.sha256

apr-1.7.0.tar.gz
apr-1.7.0.tar.gz.sha256

apr-util-1.6.1.tar.gz
apr-util-1.6.1.tar.gz.sha256
>;


if !@*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go | list

    Checks sha256 hashes for Apache2 and pre-regs

    HERE
}

my $list  = 0;
my $debug = 0;
my $exe   = 0;
for @*ARGS {
    when /^g/ { ++$exe }
    when /^d/ { ++$debug }
    when /^l/ { ++$list; $exe = 0 }
    default {
        note "FATAL: Input arg '$_' is not recognized.";
        exit;
    }
}

# work in pairs
my $nf = @fils.elems;
if $nf mod 2 {
    note "FATAL: Number of files ($nf) is an odd number, we must consider pairs.";
    exit;
}

if $list {
    say "File pairs:";
    say "    $_" for @fils;
    exit;
}

while @fils.elems {
    my $file = @fils.shift;
    my $hash = @fils.shift;
    if $hash !~~ /sha256$/ {
        #  we expect them is a certain order
        note "DEBUG: swapping files: file was: '$file', hash was '$hash'" if $debug;
        ($file, $hash) = $hash, $file;
    }
    my $fnam = $file;
    my $hnam = $hash;
    $hnam ~~ s/'.sha256'$//;
    if $fnam ne $hnam {
        note "FATAL: file and hash pair ('$file', '$hash') don't match";
        exit;
    }
}
