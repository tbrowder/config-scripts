#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Bind DNS Server."
  exit
fi

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# tbrowde-home-bzr/usrlocal

# Debian 9 and bind 9.12.3-P1:
# need Debian packages:
#   python-ply
#   liblmdb0
#   lmdb-dbg  [not for > debian 8]
#   lmdb-doc lmdb-utils liblmdb-dev
#   libjson-c-dev
#   protobuf-c-compiler
#   resolvconf
#
#   libgeoip-dev
#   libfstrm-dev
#   libprotobuf-c-dev
#   libidn2-0-dev
#   idn2
#   libunistring-dev

# if bind is installed as a package, try to remove these packages:
#   bind9-doc bind9-host bind9utils bindgraph libbind-dev libbind9-90

# run "make distclean" after config changes

# use system openssl
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
  --with-python=/usr/bin/python \
    \
  --with-tuning=default  \
  --enable-dnstap  \
  --with-geoip  \
  --with-gssapi  \
  --enable-dnsrps  \
  --enable-native-pkcs11  \
  --with-gost  \
  --with-eddsa

#  --with-libidn2=/usr/local/lib/libidn2.so



  # may need this for python:
  # --with-python=PATH

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
