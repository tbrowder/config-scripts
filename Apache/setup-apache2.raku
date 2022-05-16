#!/usr/bin/env raku

use Text::Utils :strip-comment;

# the file collection that has been downloaded:
# (must be consistent: *.tar.gz)
my $flist = 'file-list.dat';
my @lines = $flist.IO.lines;
my %fils;
for @lines -> $line is copy {
    $line = strip-comment $line;
    next if $line !~~ /\S/;

    # the source of the file is first
    my ($src, $f);
    my $idx = rindex $line, '/';
    if $idx.defined {
        $f = $line.substr: $idx+1;
        $src = $line.substr: 0, $idx; 
        if not $f.IO.r {
            say "File '$f' not found, fetching it from '$src'";
            shell "curl $line -O";
        }
    }
    else {
        die "FATAL: Unrecognized line '$line'";
    }

    %fils{$f} = $src;
}

if !@*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <opt> 

    Provides sequential steps to install Openssl and Apache2:

        list    - lists the required files
        get     - gets, confirms, and lists the required files
        unpack  - unpacks the archive files

        config  - configures each directory
        build   - builds and tests each component
        install - as root, installs each component
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
for @*ARGS {
    when /^d/ { ++$debug }
    when /^l/ { ++$list }
    when /^g/ { ++$get}
    when /^u/ { ++$unpack }

    when /^cl/ { ++$clean }
    when /^c/ { ++$config }

    when /^b/ { ++$build }
    when /^i/ { ++$install }
    when /^p/ { ++$purge }
    when /^c/ { ++$config }
    default {
        note "FATAL: Input arg '$_' is not recognized.";
        exit;
    }
}

my $nf = %fils.elems;
if $nf mod 3 {
    note "FATAL: Number of files ($nf) is not a triplet, we must consider sets of three.";
    exit;
}

if $list {
    say "File triplets:";
    say "    $_" for %fils.keys.sort;
    exit;
}

my %h;
for %fils.keys.sort {
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

    # unpack the archive
}

if $unpack {
    for %fils.keys.sort -> $f {
        say "Unpacking '$f'";
        shell "tar -xvzf $f";
    }
    exit;
}

if $ config {
    for %fils.keys.sort -> $f {
        my $idx = rindex $f, '.tar.gz';
        unless $idx.defined {
            die "FATAL: Unknown file '$f'";
        }
        my $dir = $f.substr: 0, $idx;
        say "Configuring '$dir';
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
