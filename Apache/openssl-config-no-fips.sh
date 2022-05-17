#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 <openssl version>"
  echo
  echo "  Configures openssl source (without FIPS)"
  echo "    and installs it into directory"
  echo "    '/opt/openssl-<version>'."
  echo "  Note this script is designed to be in the directory"
  echo "    above the source directory and called from within"
  echo "    that directory which should be named:"
  echo "    'openssl-<version>'"
  echo
  exit
fi

VER=$1

SSLDIR=/opt/openssl-$VER

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# see Ivan Ristics "Bulletproof SSL and TLS," p. 316

# openssl (no FIPS) ================
# we must use the shared library for some Apache friends
# do NOT use patented algorithms without permission:

# use package zlib1g-dev

# where are we?
SRCDIR=openssl-$VER
INSRCDIR="../$SRCDIR"
if [[ -d $INSRCDIR ]] ; then
    echo "Working in proper dir '$INSRCDIR'..."
elif [[ -d $SRCDIR ]] ; then
    echo "You are in the directory above dir '$SRCDIR'."
    echo "You must cd into it to execute this script."
    exit
else
    echo "Source directory '$SRCDIR' cannot be found."
    exit
fi

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

# should be finished with building the makefils
echo
echo "===================================================="
echo "Now execute 'make && make test && sudo make install'"

# make depend [don't normally need this]
# make
# make test
# sudo make install
# make distclean

# create file
#   /etc/ld.so.conf.d/openssl.conf
# containing the line:
#   /opt/openssl-<version>/lib
#   (ensure there is only ONE file pointing to ONE openssl version)
# then execute:
#   ldconfig

# make uninstall
