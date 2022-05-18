shell "mkdir tmp" if not 'tmp'.IO.d;

my $dir = "tmp";
my $wrd = 'zebra';
my $wrd2 = 'monkey';
my $prog = "run-cmd.sh";

# brute force
run "../$prog", $wrd, :cwd($dir);
run "../$prog", $wrd2, :cwd($dir);
run "rm", "-f", $wrd, :cwd($dir);

# as initial string
my ($arg0, $cmd, @args);

$cmd = "../$prog $wrd"; # :cwd($dir);
run |$cmd.words, :cwd($dir);

$cmd = "../$prog $wrd2"; # :cwd($dir);
run |$cmd.words, :cwd($dir);

$cmd = "rm -f $wrd"; # :cwd($dir);
run |$cmd.words, :cwd($dir);


