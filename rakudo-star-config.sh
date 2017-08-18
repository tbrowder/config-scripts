#!/bin/bash

# this dir is normally owned by root and used site-wide:
PREFIX=/usr/local/rakudo.d
#   user: Configure.pl ...
#   root: make install-instdir

if [[ -z "$1" ]] ; then
    echo "Usage: $0 go"
    echo
    echo "As the root user, this will configure rakudo."
    echo "  for installation into '$PREFIX'."
    echo
    echo "As root, cd to the source directory and execute:"
    echo
    echo "  # make"
    echo "  # make rakudo-test"
    echo
    echo "For more thorough, but longer, testing run:"
    echo
    echo "  # make rakudo-spectest"
    echo "  # make module-test"
    echo
    echo "Finally, install into '$PREFIX' by running:"
    echo
    echo "  # make install"
    echo
    exit
fi

# must remove old binaries and libs
rm -rf $PREFIX/bin
rm -rf $PREFIX/include
rm -rf $PREFIX/lib
rm -rf $PREFIX/share/nqp
rm -rf $PREFIX/share/pkgconfig

perl Configure.pl --gen-moar --prefix=$PREFIX
