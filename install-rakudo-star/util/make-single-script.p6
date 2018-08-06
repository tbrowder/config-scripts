#!/usr/bin/env perl6

my $debug = 0;

# generates a concatenated script
my $ofile = 'install-rakudo-star.sh';

# the base script:
my $b1 = @*ARGS.shift;
say "DEBUG: input base file '$b1'" if $debug;

# the functions script to be included
my $b2 = @*ARGS.shift;
say "DEBUG: input funcs file '$b2'" if $debug;

my $fh = open $ofile, :w;
say "DEBUG: output file '$ofile'" if $debug;

my $ignore = 0;
for $b1.IO.lines -> $line {
    if $line ~~ /'=begin' \h+ insert/ {
        say "DEBUG: found base line: '$line'" if $debug;
        $ignore = 1;
        # insert the function file
        for $b2.IO.lines -> $lin {
            $fh.say: $lin;
        }

    }
    elsif $line ~~ /'=end' \h+ insert/ {
        say "DEBUG: skipping base line: '$line'" if $debug;
        $ignore = 0;
    }
    elsif $ignore {
        say "DEBUG: skipping base line: '$line'" if $debug;
    }
    else {
        say "DEBUG: printing line: '$line'" if $debug;
        $fh.say: $line;
    }
}
$fh.close;

# make the file executable
chmod 0o755, $ofile;

say "\nSee executable bash script output file:";
say "  $ofile";
