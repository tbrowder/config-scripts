#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Cyrus SAS library."
  exit
fi

# [the source for this file is in the
# tbrowde-home-bzr/usrlocal'

# NOTE: add the following environment variable and value to handle the
# plugins properly (set it in file '/etc/environment':
#   SASL_PATH=/usr/local/lib/sasl2

# use local openssl if needed
OPENSSL_HOME=/opt/openssl

./configure \
  --with-openssl=$OPENSSL_HOME \
  --with-configdir=/usr/local/lib/sasl2 \
  --with-plugindir=/usr/local/lib/sasl2

# make
# sudo make install
# sudo ldconfig

# make clean

# make uninstall
