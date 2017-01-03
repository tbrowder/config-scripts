#!/usr/bin/env perl

use feature 'say';

my $arch = shift @ARGV;

my @suffs = qw(
  .zip
  .tar.gz
);

foreach my $suff (@suffs) {
    my $a = $arch;
    if ($a =~ s/$suff//) {
	print $a;
	exit
    };
    #say "archdir: '$a'";
    #say "suf:     '$suff'";
    #say "archdir: '$a'";
}
