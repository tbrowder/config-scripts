#!/bin/bash

KNOWN_VERS="1.1.0e 1.1.0f"
if [ -z "$1" ] ; then
  echo "Usage: $0 <openssl version>"
  echo
  echo "  Configures openssl source (without FIPS)"
  echo "    from known versions: '$KNOWN_VERS'"
  echo "    and installs it into directory"
  echo "    '/opt/openssl-<version>'."
  echo
  exit
fi

VER=$1
GOODVER=
for ver in $KNOWN_VERS
do
    if [[ $1 = $ver ]] ; then
        GOODVER=$ver
    fi
done
if [[ -z $GOODVER ]] ; then
    echo "FATAL:  Openssl version $VER is not known."
    exit
fi

SSLDIR=/opt/openssl-$VER

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# see Ivan Ristics "Bulletproof SSL and TLS," p. 316

# openssl (no FIPS) ================
# we must use the shared library for some Apache friends
# do NOT use patented algorithms without permission:

# use package zlib1g-dev


./config \
    no-ec2m                         \
    no-rc5                          \
    no-idea                         \
    threads                         \
    zlib-dynamic                    \
    shared                          \
    --prefix=${SSLDIR}              \
    --openssldir=${SSLDIR}          \
    enable-ec_nistp_64_gcc_128

# make depend [don't normally need this]
# make
# make test
# sudo make install
# make clean

# create file
#   /etc/ld.so.conf.d/openssl.conf
# containing the line:
#   /opt/openssl-<version>/lib
#   (ensure there is only ONE file pointing to ONE openssl version)
# then execute:
#   ldconfig

# make uninstall
