#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures openssl source (without FIPS)."
  exit
fi

# use latest gcc?
USE_LATEST=
if [[ -n "$USE_LATEST" ]] ; then
  GCCVER=5.2.0
  GCCBINDIR=/usr/local/gcc/${GCCVER}/bin
  CC=${GCCBINDIR}/gcc
  CXX=${GCCBINDIR}/g++
  CPP=${GCCBINDIR}/cpp
else
  CC=gcc
  CXX=g++
  CPP=cpp
fi

# see Ivan Ristics "Bulletproof SSL and TLS," p. 316

# openssl (no FIPS) ================
# we must use the shared library for some Apache friends
# do NOT use patented algorithms without permission:

SSLDIR=/usr/local/opt/openssl

./config \
    no-ec2m                         \
    no-rc5                          \
    no-idea                         \
    threads                         \
    zlib-dynamic                    \
    shared                          \
    --prefix=${SSLDIR}              \
    --openssldir=${SSLDIR}          \
    enable-ec_nistp_64_gcc_128      \


# make depend
# make
# make test
# sudo make install
# make clean
