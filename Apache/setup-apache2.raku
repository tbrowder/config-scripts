#!/usr/bin/env raku

use Text::Utils :strip-comment;
use JSON::Fast;

# the file collection that has been downloaded:
# (must be consistent: *.tar.gz)
my $flist = 'file-list.dat';       # desired files to be used
my $jfil  = '.apache-setup.json';  # formatted hash with all data
show-infiles-format($flist) if not $flist.IO.r; # exits from sub
create-jfil(:$flist, :$jfil, :debug(1)) if not $jfil.IO.r or $flist.IO.modified > $jfil.IO.modified;
my %data = from-json(slurp $jfil);

if !@*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <opt> [o|a] [help, debug]

    Provides sequential steps to install Openssl and Apache2.
    Note: You MUST install Openssl BEFORE Apache2.

        list    - lists the required files
        get     - gets, confirms, and lists the required files
        unpack  - unpacks the archive files

        config  o|a - configures a directory
        build   o|a - builds and tests a component
        install o|a - as root, installs a component

        clean   - removes component directories
        purge   - removes component directories and downloaded files
    HERE
    exit;
}

my $debug   = 0;

my $list    = 0;
my $get     = 0;
my $unpack  = 0;
my $config  = 0;
my $build   = 0;
my $install = 0;
my $clean   = 0;
my $purge   = 0;
my $o       = 0;
my $a       = 0;
for @*ARGS {
    when /^d/  { ++$debug   }
    when /^h/  { help       } # exits from the sub

    when /^l/  { ++$list    }
    when /^g/  { ++$get     }
    when /^u/  { ++$unpack  }

    when /^cl/ { ++$clean   }
    when /^c/  { ++$config  }

    when /^b/  { ++$build   }
    when /^i/  { ++$install }
    when /^p/  { ++$purge   }
    when /^c/  { ++$config  }
    default {
        note "FATAL: Input arg '$_' is not recognized.";
        exit;
    }
}

if $list {
    say "File triplets:";
    for %data.keys.sort.reverse -> $f {
        next if $f ~~ /version/;
        say "  $f";
        my $s = %data{$f}<sha256>;
        my $a = %data{$f}<asc>;
        say "    $s";
        say "    $a";
    }
    exit;
}


if $unpack {
    for %data.keys.sort -> $f {
        say "Unpacking '$f'";
        shell "tar -xvzf $f";
    }
    exit;
}

if $config {
    for %data.keys.sort -> $f {
        my $idx = rindex $f, '.tar.gz';
        unless $idx.defined {
            die "FATAL: Unknown file '$f'";
        }
        my $dir = $f.substr: 0, $idx;
        unless $dir.IO.d {
            die "FATAL: Unable to find directory '$dir'";
        }
        say "Configuring directory '$dir'";

        my $sprog;
        if $dir ~~ /apache/ {
            $sprog = 'apache2-config-user-openssl.sh';
            # need the openssl version
            my $idx = index 
            shell "cd $dir; ../$sprog";
        }
        else {
            $sprog = 'openssl-config-no-fips.sh';
            shell "cd $dir; ../$sprog";
        }

    }
    exit;
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

sub show-infiles-format($f) {
    say qq:to/HERE/;
    You must create a file named '$f' consisting of a list of
    the latest released source archives, sha256 check sums, and
    signature data as in the following example. Comments are
    ignored:

        # latest Openssl and Apache2 source files as of 2022-05-16
        https://www.openssl.org/source/openssl-3.0.3.tar.gz           # openssl archive file
        https://www.openssl.org/source/openssl-3.0.3.tar.gz.sha256    #   its sha checksum
        https://www.openssl.org/source/openssl-3.0.3.tar.gz.asc       #   its crypo signature
        https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz        # httpd archive file
        https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz.sha256 #   its sha check sum
        https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz.asc    #   its crypo signature
    HERE

    exit;
} # sub show-infiles-format

sub create-jfil(:$flist, :$jfil, :$debug) {
    # reads formatted file $flist, creates the desired
    # data hash, and saves it as a JSON string file

    my @lines = $flist.IO.lines;
    my %downfils;
    for @lines -> $line is copy {
        $line = strip-comment $line;
        next if $line !~~ /\S/; # skip blank lines

        $line .= trim;
        # the source of the file is first
        my ($src, $f);
        my $idx = rindex $line, '/';
        if $idx.defined {
            $f = $line.substr: $idx+1;
            $src = $line.substr: 0, $idx; 
            if $debug {
                note qq:to/HERE/;
                DEBUG file-list.dat line '$line'
                  src = '$src'
                  f   = '$f'
                HERE
            }
            if not $f.IO.r {
                say "File '$f' not found, fetching it from '$src'";
                shell "curl $line -O";
            }
        }
        else {
            die "FATAL: Unrecognized line '$line'";
        }

        %downfils{$f} = $src;
    }

    my $nf = %downfils.elems;
    if $nf mod 3 {
        note "FATAL: Number of files ($nf) is not a triplet, we must consider sets of three.";
        exit;
    }

    my %h;
    for %downfils.keys.sort {
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
                die "FATAL: This code currently does not allow for sha512 checksums.";
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
            # also pick up the openssl version
            unless %h<openssl-version>:exists {
                # remove the 'openssl-' from the front
                # remove the '.tar.gz' from the rear
                if $fil ~~ /^ 'openssl-' (\S+) '.tar.gz' / {
                    %h<openssl-version> = ~$0;
                }
                else {
                    die "FATAL: Unexpected Openssl file archive format: '$fil'";
                }
            }

        }
        # now check the file
        shell "{$sha}sum --check $sha-fil";
    }
    my $jstr = to-json %h;
    spurt $jfil, $jstr;

} # sub create-jfil

sub help() {
    # exits after showing info
    say qq:to/HERE/;
    HERE

    exit;
} # sub help

