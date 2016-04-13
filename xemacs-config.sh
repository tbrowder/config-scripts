#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures the XEmacs editor."
  exit
fi

# stable xemacs
PREFIX=/usr/local
# for xemacs-beta:
PREFIX=/usr/local/opt

./configure \
  --with-prefix=$PREFIX \
  --with-mule

# make
# make check
# sudo make install
# sudo ldconfig

# POST-INSTALL
#   then place a copy of two package files:
#
#     xemacs-mule-sumo.tar.bz2
#     xemacs-sumo.tar.bz2
#
#   in directory '/usr/local/lib/xemacs' and unpack them:
#
#   # cp xemacs-mule-sumo.tar.bz2 xemacs-sumo.tar.bz2 /usr/local/lib/xemacs
#   # cd /usr/local/lib/xemacs
#   # tar -xvjf xemacs-mule-sumo.tar.bz2
#   # tar -xvjf xemacs-sumo.tar.bz2
#
#   the archive files may be deleted after unpacking
#
#   don't forget the .xemacs directory in $HOME
