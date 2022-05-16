#!/usr/bin/env raku

# the file collection that has been downloaded:
# (must be consistent: *.tar.gz)
my @fils = <
openssl-3.0.3.tar.gz
openssl-3.0.3.tar.gz.sha256
openssl-3.0.3.tar.gz.asc

httpd-2.4.53.tar.gz
httpd-2.4.53.tar.gz.sha512
httpd-2.4.53.tar.gz.asc
>;


if !@*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go | list

    Checks shasum hashes for Apache2 and pre-regs

    HERE
    exit;
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
if $nf mod 3 {
    note "FATAL: Number of files ($nf) is not a triplet, we must consider sets of three.";
    exit;
}

if $list {
    say "File triplets:";
    say "    $_" for @fils;
    exit;
}

my %h;
#my $key;
for @fils {
    my $fil = $_;
    say "Working file '$fil'...";
    my ($k, $typ, $f);

    with $fil {
        when /(.*) '.' (sha256) $/ {
            $k   = ~$0;
            $typ = ~$1;
            $f   = $fil;
        }
        when /(.*) '.' (sha512) $/ {
            $k   = ~$0;
            $typ = ~$1;
            $f   = $fil;
        }
        when /(.*) '.' (asc) $/ {
            $k   = ~$0;
            $typ = ~$1;
            $f   = $fil;
        }
        when /(.* '.' gz) $/ {
            $k = ~$0;
        }
        default {
            say "WARNING: Unexpected file name '$_'";
            say "         Skipping it...";
        } 
    }
    
    if $k.defined {
        print "  Found key '$k'";
        if $typ.defined and $f.defined {
            say " and found type '$typ' and file '$f'.";
            %h{$k}{$typ} = $f;
        }
        else {
            say ".";
        }
    }
}

say %h.raku if $debug;

for %h.keys -> $fil {
    my $asc = %h{$fil}<asc>:exists ?? %h{$fil}<asc> !! 0;
    my $sha = %h{$fil}<sha256>:exists ?? 'sha256'
                                      !! (%h{$fil}<sha512>:exists) ?? 'sha512' !! 0;
    my $sha-fil = %h{$fil}{$sha};

    # check the shasum
    # if it's an openssl one, the file is probably bad
    if $fil ~~ /openssl/ {
        my $s = slurp $sha-fil;
        my @w = $s.words;
        if @w.elems == 1 {
            $s .= chomp;
            $s ~= " $fil";
            spurt $sha-fil, $s; 
        }
    }
    # now check the file
    shell "{$sha}sum --check $sha-fil";

}

    =begin comment
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
    try {
        shell "sha256sum --check $hash";
        CATCH {
            my $msg = .Str;
            note "DEBUG: err is: $msg" if $debug;
            when /openssl/ {
                note "Correcting incorrect format of openssl sha256sum file...";
                # rewrite the file and test it again
                my $sha = slurp $hash;
                $sha .= trim;
                note "  Original:  $sha";
                my $sha256 = "$sha $file";
                note "  Corrected: $sha256";
                spurt $hash, $sha256;
                shell "sha256sum --check $hash";
                .resume;
            } 
            note "Skipping...";
            .resume;
        }
    }
    =end comment
