#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Sympa"
  exit
fi

#  Optional Features:

./configure

# make
# sudo make install
