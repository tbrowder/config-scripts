#!/usr/bin/env raku


use File::Find;

# dir to search h*3/docs/manual/mod -name "mod_*html.en"

my $debug  = 0;
my $ver    = '2.4.43';
my $srcdir = "httpd-$ver";
my $dir    = "$srcdir/docs/manual/mod";
my $ofil   = "modules.$ver.list";
if !@*ARGS {
    say qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go | 'x.y.z'

    The default action is to extract module file info from Apache2 source dir '$dir'
        and write into file '$ofil'.

    Enter a different version if you desire.
    HERE
    exit;
}

for @*ARGS {
    when /^(\d+ '.' \d+ '.' \d+) $/ {
        $ver    = ~$0;
        $srcdir = "httpd-$ver";
        $dir    = "$srcdir/docs/manual/mod";
        $ofil   = "modules.$ver.list";
    }
    when /^d/ { $debug = 1 }
    when /^g/ {
        ; # ok
    }
    default {
        note "FATAL: Unknown arg '$_'";
        exit;
    }
}

say "Processing module in src dir '$srcdir'...";

my @fils = find :$dir, :name(/'mod_' \S+ '.html.en'$/), :type<file>, :keep-going;

# output into a file list
my $fh = open $ofil, :w;

my $nm = 0;
my $nf = 0;
for @fils {
    # try to open it specially
    my $s = slurp($_, enc => 'utf8-c8');
    my $fnam = $_;
    ++$nf;
    $fh.say: "#=== file: $fnam" if $debug;
    my ($mod-descrip, $mod-id, $mod-src);
    for $s.lines {
        .say if $debug;

        # capture the description
        if $_ ~~ /(Description)  \N+ '<td>' (\N+) \s*'</td>' / {
            say ~$0 if $debug;
            say ~$1 if $debug;

            $mod-descrip = ~$1;
        }
        #elsif $_ ~~ /(ModuleIdentifier) \N+ '<td>' \s* (proxy_ftp_module) \s* '</td>' \s* '</tr>' \s* $/ {
        elsif $_ ~~ /('ModuleIdentifier') \N+ '<td>' (\S+) \s*'</td>'/ {
            say ~$0 if $debug;
            say ~$1 if $debug;

            $mod-id = ~$1;
        }
        #elsif $_ ~~ /(SourceFile) \N+ '<td>' \s* (mod_proxy_ftp.c) \s* '</td>' \s* '</tr>' \s* '</table>' \s* $/ {
        elsif $_ ~~ /('SourceFile') \N+ '<td>' (\S+) \s* \N* '</td>'/ {
            say ~$0 if $debug;
            say ~$1 if $debug;

            $mod-src = ~$1;
            # eliminate any .c
            $mod-src ~~ s/'.c'$//;
            if $debug {
                $fh.print: "  mod-src: $mod-src";
                $fh.say:   "  mod-id: $mod-id";
            }
            else {
                # use format for Apache
                $fh.say("#    Description: $mod-descrip") if $mod-descrip;
                $fh.say: "#LoadModule {$mod-id}    modules/{$mod-src}.so";
            }
            ++$nm;
        }
    }
    last if $debug;
}
$fh.close;
say "Normal end. Found $nm modules listed in $nf files.\nSee output file:";
say "  $ofil";


=finish
    my $s;
    try {

        $s = slurp $_;
        say "Slurped file $_";
    }
    if $! {
            say "Malformed file $_";
            say .Str;
    }

        CATCH {
            say "Malformed file $_";
            say .Str;
            next;
            .resume;
        }

    next if !$;
    for $s.lines {
        .say;
        if $_ ~~ /(ModuleIdentifier)/ {
            say ~$0;
        }
        elsif $_ ~~ /(SourceFile)/ {
            say ~$0;
            last;
        }
    }

    last if $debug;
}
