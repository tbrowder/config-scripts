#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures the XEmacs editor."
  exit
fi

./configure \
  --with-openssl=$OPENSSL_HOME \
  --with-configdir=/usr/local/lib/sasl2 \
  --with-plugindir=/usr/local/lib/sasl2

# make
# sudo make install
# sudo ldconfig

# make clean

# make uninstall
