#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Bind DNS Server."
  exit
fi

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# tbrowde-home-bzr/usrlocal

# need Debian packages:
#   python-ply
#   liblmdb0
#   lmdb-dbg  [not for > debian 8]
#   lmdb-doc lmdb-utils liblmdb-dev
#   libjson-c-dev
#   protobuf-c-compiler
#   resolvconf

# if bind is installed as a package, try to remove these packages:
#   bind9-doc bind9-host bind9utils bindgraph libbind-dev libbind9-90

# use only for my local host juvat2:
# recommended for all hosts:

# didn't work with deb 8 on dedi2
# bit DID work on deb 9 on ns2
#OPENSSL_HOME=/opt/openssl
#  --with-openssl=$OPENSSL_HOME \

# run "make distclean" after config changes

./configure \
  --with-openssl=yes \
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
  --with-python=/usr/bin/python

  # may need this for python:
  # --with-python=PATH

# these two need other libraries not yet found:
#  --enable-native-pkcs11      \
#  --enable-dnstap             \

# make (Do not use a parallel "make".)
#   takes about 7 min

# A limited test suite can be run with "make test".  Many of
# the tests require you to configure a set of virtual IP addresses
# on your system, and some require Perl; see bin/tests/system/README
# for details.

# make test
#   requires a sudo test config;
#   takes about 38 minutes

# sudo make install
# sudo ldconfig
# make clean

# make uninstall
