#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Bind DNS Server."
  exit
fi

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# tbrowde-home-bzr/usrlocal'

# need Debian packages:
#   python-ply
#   liblmdb0 lmdb-dbg lmdb-doc lmdb-utils liblmdb-dev
#   libjson-c-dev
#   protobuf-c-compiler

# use local openssl if needed
OPENSSL_HOME=/usr/local/opt/openssl

# run "make distclean" after config changes

./configure \
  --with-openssl=$OPENSSL_HOME \
  --with-pkcs11                \
  --enable-seccomp             \
  --with-atf                   \
  --with-libtool               \
  --with-atf                   \
  --with-python                \
  --with-libjson               \
  --enable-full-report         \
  --with-lmdb                  \
  --enable-fixed-rrset         \
  --with-zlib                  \
  --enable-querytrace          \

# these two need other libraries not yet found:
#  --enable-native-pkcs11      \
#  --enable-dnstap             \



# make (Do not use a parallel "make".)

# sudo make install

# sudo ldconfig

# make clean

# make uninstall
