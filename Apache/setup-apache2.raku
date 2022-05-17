#!/usr/bin/env raku

use Text::Utils :strip-comment;
use JSON::Fast;

# the file collection that has been downloaded:
# (must be consistent: *.tar.gz)
my $flist = 'file-list.dat';       # desired files to be used
my $jfil  = '.apache-setup.json';  # formatted hash with all data
show-infiles-format($flist) if not $flist.IO.r; # exits from sub
create-jfil(:$flist, :$jfil, :debug(0)) if not $jfil.IO.r or $flist.IO.modified > $jfil.IO.modified;
my %data = from-json(slurp $jfil);
my $nmf = check-files %data;

if not @*ARGS.elems {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <opt> [o|a] [help, force, debug]

    Provides sequential steps to install Openssl and Apache2.
    Note: You MUST install Openssl BEFORE Apache2.

        list    - lists the required files
        get [r] - gets, confirms, and lists the required files
                  (add the 'r' option to refresh any existing file)
        unpack  - unpacks the archive files

        config  o|a - configures a directory
        build   o|a - builds and tests a component
        dclean  o|a - runs 'make distclean' in a component directory
        install o|a - as root, installs a component

        clean   - removes all local component directories
        purge   - removes all local component directories and downloaded files

    HERE

    nmf-warning($nmf, :indent) if $nmf;

    exit;
}


my $debug   = 0;
my $force   = 0;
my $refresh = 0;

my $list    = 0;
my $get     = 0;
my $unpack  = 0;
my $config  = 0;
my $build   = 0;
my $install = 0;
my $clean   = 0;
my $dclean  = 0;
my $purge   = 0;
my $o       = 0;
my $a       = 0;
for @*ARGS {
    when /^de/ { ++$debug   }
    when /^d/  { ++$dclean  }
    when /^h/  { help       } # exits from the sub
    when /^f/  { ++$force   }
    when /^r/  { ++$refresh }

    when /^l/  { ++$list    }
    when /^g/  { ++$get     }
    when /^u/  { ++$unpack  }

    when /^cl/ { ++$clean   }
    when /^p/  { ++$purge   }

    # these three options need an o or a to select which component to operate on
    when /^c/  { ++$config  }
    when /^b/  { ++$build   }
    when /^i/  { ++$install }

    when /^o/  { ++$o; $a = 0 }
    when /^a/  { ++$a; $o = 0 }

    default {
        note "FATAL: Input arg '$_' is not recognized.";
        exit;
    }
}

nmf-warning($nmf) if $nmf and not $get;

if $get {
    say "Getting and checking required files...";
    get-check-files :$refresh;
    exit;

    # do we have all the files needed?
    for %data<fils>.keys.sort -> $f {
        say "Unpacking '$f'";
        shell "tar -xvzf $f";
    }
    exit;
}

if $list {
    say "File triplets:";
    for %data<fils>.keys.sort.reverse -> $f {
        say "  $f";
        my $s = %data<fils>{$f}<sha256>;
        my $a = %data<fils>{$f}<asc>;
        say "    $s";
        say "    $a";
    }
    exit;
}

if $unpack {
    for %data<fils>.keys.sort -> $f {
        say "Unpacking '$f'";
        shell "tar -xvzf $f";
    }
    exit;
}

if $dclean and ($o or $a) {
    my $dir;
    # apache, so openssl must be installed
    my $odir = %data<oidir>;
    if $a and not $odir.IO.d  {
        if not $force {
            note "FATAL: Openssl has not been installed in dir '$odir'";
            note "       Use the 'force' option to override.";
            exit;
        }
        else {
            note "WARNING: Openssl has not been installed in dir '$odir'";
        }
    }

    if $a {
        $dir = %data<aldir>;
        say "Running 'make distclean' in dir '$dir'";
    }
    elsif $o {
        $dir = %data<oldir>;
        say "Running 'make distclean' in dir '$dir'";
    }
    else { die "FATAL: Neither $a nor $o has been selected"; }
    shell "cd $dir; make distclean";
    note "WARNING: Openssl has not been installed in dir '$odir'" if $a and not $odir.IO.d;

    exit;
}

if $build  {
    if not ($o or $a) {
        say "FATAL: With 'build' you must also enter 'o' (for 'openssl') or 'a' (for 'apache').";
        exit;
    }
    my $dir;
    # apache, so openssl must be installed
    my $odir = %data<oidir>;
    if $a and not $odir.IO.d  {
        if not $force {
            note "FATAL: Openssl has not been installed in dir '$odir'";
            note "       Use the 'force' option to override.";
            exit;
        }
        else {
            note "WARNING: Openssl has not been installed in dir '$odir'";
        }
    }

    if $a {
        $dir = %data<aldir>;
        say "Building Apache in dir '$dir'";
    }
    elsif $o {
        $dir = %data<oldir>;
        say "Building Openssl in dir '$dir'";
    }
    else { die "FATAL: Neither $a nor $o has been selected"; }
    
    shell "cd $dir; make";
    shell "cd $dir; make test" if $o;
    note "WARNING: Openssl has not been installed in dir '$odir'" if $a and not $odir.IO.d;

    exit;
}

if $install {
    if not ($o or $a) {
        say "FATAL: With 'install' you must also enter 'o' (for 'openssl') or 'a' (for 'apache').";
        exit;
    }
    my $dir;
    # apache, so openssl must be installed
    my $odir = %data<oidir>;
    if $a and not $odir.IO.d  {
        if not $force {
            note "FATAL: Openssl has not been installed in dir '$odir'";
            note "       Use the 'force' option to override.";
            exit;
        }
        else {
            note "WARNING: Openssl has not been installed in dir '$odir'";
        }
    }

    if $a {
        $dir = %data<aidir>;
        say "Installing Apache in dir '$dir'";
    }
    elsif $o {
        $dir = %data<oidir>;
        say "Installing Openssl in dir '$dir'";
    }
    else { die "FATAL: Neither $a nor $o has been selected"; }
    note "WARNING: Openssl has not been installed in dir '$odir'" if $a and not $odir.IO.d;

    exit;
}

if $config  {
    if not ($o or $a) {
        say "FATAL: With 'config' You must also enter 'o' (for 'openssl') or 'a' (for 'apache').";
        exit;
    }
    my $dir;
    my $sprog;
    # apache, so openssl must be installed
    my $odir = %data<oidir>;
    if $a and not $odir.IO.d  {
        if not $force {
            note "FATAL: Openssl has not been installed in dir '$odir'";
            note "       Use the 'force' option to override.";
            exit;
        }
        else {
            note "WARNING: Openssl has not been installed in dir '$odir'";
        }
    }

    if $a {
        $dir = %data<aldir>;
        say "Configuring Apache in dir '$dir'";
        # apache, so openssl must be installed
        my $odir = %data<oidir>;
        note "WARNING: Openssl has not been installed in dir '$odir'" if not $odir.IO.d;
        $sprog = 'apache2-config-user-openssl.sh';
    }
    elsif $o {
        $dir = %data<oldir>;
        say "Configuring Openssl in dir '$dir'";
        $sprog = 'openssl-config-no-fips.sh';
    }

    unless $dir.IO.d {
        die "FATAL: Unable to find directory '$dir'";
    }

    # need the openssl version
    my $over = %data<over>;
    shell "cd $dir; ../$sprog $over";
    note "WARNING: Openssl has not been installed in dir '$odir'" if $a and not $odir.IO.d;

    exit;
}

if $clean {
    # clean - removes all local component directories
    # require 'force' to actually remove anything

    my $odir = %data<oldir>;
    my $adir = %data<aldir>;

    if not $force {
        print qq:to/HERE/;
        With option 'force', the following commands will be executed:
            \$ rm -rf {$odir}
            \$ rm -rf {$adir}
        HERE
    }
    else {
        shell "rm -rf {$odir}";
        shell "rm -rf {$adir}";
    }
}

if $purge {
    # purge - removes all local component directories and downloaded files
    # require 'force' to actually remove anything

    my $odir = %data<oldir>;
    my $adir = %data<aldir>;

    if not $force {
        print qq:to/HERE/;
        With option 'force', the following commands will be executed:
            \$ rm -rf {$odir}
            \$ rm -rf {$adir}
        HERE

        for %data<fils>.keys.sort.reverse -> $f {
            say "    \$ rm $f";
            my $s = %data<fils>{$f}<sha256>;
            my $a = %data<fils>{$f}<asc>;
            say "    \$ rm $s";
            say "    \$ rm $a";
        }
    }
    else {
        shell "rm -rf {$odir}";
        shell "rm -rf {$adir}";

        for %data<fils>.keys.sort.reverse -> $f {
            shell "rm $f";
            my $s = %data<fils>{$f}<sha256>;
            my $a = %data<fils>{$f}<asc>;
            shell "rm $s";
            shell "rm $a";
        }
    }


    =begin commemt
    for %data<fils>.keys.sort.reverse -> $f {
        say "  $f";
        my $s = %data<fils>{$f}<sha256>;
        my $a = %data<fils>{$f}<asc>;
        say "    $s";
        say "    $a";
    }
    =end commemt

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

sub get-check-files(:$refresh) {
} # get-check-files

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
            =begin comment
            if not $f.IO.r {
                say "File '$f' not found, fetching it from '$src'";
                shell "curl $line -O";
            }
            =end comment
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
        say "Working file '$fil'..." if $debug;
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
                %h<fils>{$k}{$typ} = $f;
            }
            else {
                say ".";
            }
        }
    }

    say %h.raku if $debug;
    for %h<fils>.keys -> $fil {
        my $asc = %h<fils>{$fil}<asc>:exists ?? %h<fils>{$fil}<asc> !! 0;
        my $sha = %h<fils>{$fil}<sha256>:exists ?? 'sha256'
                                                !! (%h<fils>{$fil}<sha512>:exists) ?? 'sha512' !! 0;
        my $sha-fil = %h<fils>{$fil}{$sha};

        # check the shasums
        if $fil ~~ /httpd/ {
            # pick up the httpd version
            unless %h<aver>:exists {
                # remove the 'httpd-' from the front
                # remove the '.tar.gz' from the rear
                if $fil ~~ /^ 'httpd-' (\S+) '.tar.gz' / {
                    my $ver   = ~$0;
                    %h<aver>  = $ver;
                    %h<aldir> = 'httpd-' ~ $ver;
                    %h<aidir> = '/usr/local/apache2';
                }
                else {
                    die "FATAL: Unexpected Apache2 file archive format: '$fil'";
                }
            }
        }
        # if it's an openssl one, the file is probably bad
        if $fil ~~ /openssl/ {
            =begin comment
            my $s = slurp $sha-fil;
            my @w = $s.words;
            if @w.elems == 1 {
                $s .= chomp;
                $s ~= " $fil";
                spurt $sha-fil, $s; 
            }
            =end comment
            # also pick up the openssl version
            unless %h<over>:exists {
                # remove the 'openssl-' from the front
                # remove the '.tar.gz' from the rear
                if $fil ~~ /^ 'openssl-' (\S+) '.tar.gz' / {
                    my $ver   = ~$0;
                    %h<over>  = $ver;
                    %h<oldir> = 'openssl-' ~ $ver;
                    %h<oidir> = '/opt/openssl-' ~ $ver;
                }
                else {
                    die "FATAL: Unexpected Openssl file archive format: '$fil'";
                }
            }
        }

        =begin comment
        # now check the file
        shell "{$sha}sum --check $sha-fil";
        =end comment
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

sub check-files(%data) {
    # checks presence of required files
    my $err = 0;
    for %data<fils>.keys.sort.reverse -> $f {
        ++$err if not $f.IO.r;
        my $s = %data<fils>{$f}<sha256>;
        my $a = %data<fils>{$f}<asc>;
        ++$err if not $s.IO.r;
        ++$err if not $a.IO.r;
    }
    $err;
}

sub nmf-warning($nmf, :$indent) {
    my $spaces = '';
    $spaces = (' ' x 4) if $indent;

    say "{$spaces}WARNING: $nmf required source files are missing.";
    say "{$spaces}         Use the 'get' mode to restore and confirm them.";
    say "{$spaces}         Use the 'refresh' option to get and confirm all of them.";
    say "{$spaces}         Expect unhandled exceptions without a complete file set.";
    say();
} # sub nmf-warning
