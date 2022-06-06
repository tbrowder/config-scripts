use Config::TOML;

my $f = q:to/HERE/;
[key1]
a = 'b'
b = 1
HERE


my %h = from-toml $f;
say %h;
