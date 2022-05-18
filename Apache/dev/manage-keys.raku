#!/usr/bin/env raku

use Text::Utils :strip-comment;

my $okey-data = 'openssl-fingerprints.dat';

sub read-openssl-fingerprints($f, :$debug --> Hash) is export {
    my %h;
    for $f.IO.lines -> $line is copy {
        $line = strip-comment $line;
        next if $line !~~ /\S/;

        my @w = $line.words;
        my $fp = @w.shift.Str;
        my $name = @w.join(' ');
        if $debug {
            say "DEBUG: fp: $fp";
            say "     name: $name";
        }

        %h{$fp} = $name;
    }
    %h
} # sub read-openssl-fingerprints

my $debug  = 0;
my $go     = 0;

if not @*ARGS.elems {
    say qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Manipulates signature data from Openssl and Apache2.
    HERE

    exit;
}

for @*ARGS {
    when /^d/ { ++$debug    }
    when /^g/ { ++$go       }
    default {
        note "FATAL: Unknown arg '$_'";
        exit;
    }
}

my %of = read-openssl-fingerprints($okey-data);
say "Openssl developer key fingerprints:";
for %of.kv -> $k, $v {
    say "Fingerprint: $k";
    say "  Developer: $v";
}

run "gpg --list-sigs".words.flat;

=begin comment
gpg --list-sigs

gpg --verify httpd-2.4.18.tar.gz.asc httpd-2.4.18.tar.gz


=end comment

=begin comment
# from the apache KEYS file
This file contains the PGP keys of various developers that work on
the Apache HTTP Server and its subprojects.

Please don't use these keys for email unless you have asked the owner
because some keys are only used for code signing.

Please realize that this file itself or the public key servers may be
compromised.  You are encouraged to validate the authenticity of these keys in
an out-of-band manner.  For information about our validation and signing
policies, please read http://httpd.apache.org/dev/verification.html.

Apache users: pgp < KEYS
Apache developers:
        (pgpk -ll <your name> && pgpk -xa <your name>) >> this file.
      or
        (gpg --fingerprint --list-sigs <your name>
             && gpg --armor --export <your name>) >> this file.

Apache developers: please ensure that your key is also available via the
PGP keyservers (such as pgpkeys.mit.edu).

Type Bits/KeyID    Date       User ID
pub  1024/2719AF35 1995/05/13 Ben Laurie <ben@algroup.co.uk>
                              Ben Laurie <ben@gonzo.ben.algroup.co.uk>

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: 2.6.3ia
=end comment
