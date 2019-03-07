#!/usr/bin/env bash

PREFIX=/usr/local/sympa
if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Sympa into dir '$PREFIX'"
  exit
fi

#  Optional Features:
MAKEMAP=/usr/sbin/makemap
NEWALIASES=/usr/sbin/newaliases
#  These binaries should be auto-found:
#    postalias
#    postmap

./configure \
  --prefix=$PREFIX \
  --with-confdir=$PREFIX/etc \
  --with-makemap=$MAKEMAP \
  --with-newaliases=$NEWALIASES \
  --enable-fhs \
  --without-initdir \
  --with-unitsdir=/lib/systemd/system

# make
# sudo make install
