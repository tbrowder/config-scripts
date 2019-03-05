#!/usr/bin/env bash

PREFIX=/usr/local/sympa
if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Sympa into dir '$PREFIX'"
  exit
fi

#  Optional Features:
MAKEMAP=$PREFIX/makemap
NEWALIASES=$PREFIX//newaliases
POSTALIAS=$PREFIX/postalias
POSTMAP=$PREFIX/postmap

./configure \
  --enable-fhs \
  --prefix=/usr/local/sympa \
  --with-confdir=/etc/sympa \
  --without-initdir \
  --with-unitsdir=/lib/systemd/system \
               \
  --with-makemap=$MAKEMAP \
  --with-newaliases=$NEWALIASES \
  --with-postalias=$POSTALIAS \
  --with-postmap=$POSTMAP

# make
# sudo make install
