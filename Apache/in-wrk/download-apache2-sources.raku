#!/usr/bin/env raku

my %apache2 = %(
    version => "2.4.43",
    date    => "released 2020-04-01",
    link    => "https://downloads.apache.org/httpd/httpd-{%apache2<version>}.tar.gz",
    pgp     => "https://downloads.apache.org/httpd/httpd-{%apache2<version>}.gz.asc",
    sha256  => "2624e92d89b20483caeffe514a7c7ba93ab13b650295ae330f01c35d5b50d87f *httpd-{%apache2<version>}.tar.gz",
);

my %apr = %(
    link => "",
    date => "",
);
my %apr-util = %(
    link => "",
);
my %pcre = %(
    link => "",
);
my %openssl = %(
    link => "",
);

if !@*ARGS {
    say qq:to/HERE/;
    Usage: {$*program.basename} go

    Downloads sources for Apache2 and pre-reqs from:

    HERE
}
