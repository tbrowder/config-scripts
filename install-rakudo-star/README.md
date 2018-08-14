# Installation scripts for the Rakudo Perl 6 Star distribution

The **Rakudo Perl 6 Star** distribution is released quarterly from <https://rakudo.org>.

### This directory has two scripts, the second one created with the Perl 6 program in directory "util/":

1. 0-download-rakudo-star.sh

    + Downloads a tgz archive of the latest Rakudo Perl 6 package (which
      is usually updated quarterly) and unpacks it in the current
      directory.

2. install-rakudo-star.sh

    + An install script to be run from inside the directory created by the previous script.

    + The script will install the Perl 6 files, along with a collection of useful modules, into directory:

        /opt/rakudo.d

    +  The script will also output a script to be sourced to update the user's path to use the new files.


The installation scripts above are based on the following text is from
the Rakudo Perl 6 website: https://rakudo.org/files/star/source


```
=============================================================================
The exact steps required may differ, depending on your operating system:

mkdir ~/rakudo && cd $_
curl -LJO https://rakudo.org/latest/star/source
tar -xzf rakudo-star-*.tar.gz
mv rakudo-star-*/* .
rm -fr rakudo-star-*

perl Configure.pl --backend=moar --gen-moar
make

# If you wish, you can run the tests
# Depending on your machine, they could take over half an hour to run
make rakudo-test
make rakudo-spectest

make install

echo "export PATH=$(pwd)/install/bin/:$(pwd)/install/share/perl6/site/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc
=============================================================================
```
