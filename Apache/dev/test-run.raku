shell "mkdir tmp" if not 'tmp'.IO.d;

my $dir = "tmp";
my $prog = "run-cmd.sh";
run "../$prog", :cwd($dir);

exit;
my $cmd = 'echo "boo" > "foo"';
#shell "echo 'boo' > 'foo'", :cwd('tmp');
run "echo",  "'boo' > 'foo'", :cwd('tmp');

#shell $cmd, :cwd('tmp'); 
exit;


