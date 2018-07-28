#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Subversion (last tested on version 1.10.0)."
  exit
fi

# Debian packages required
#
#   libapr1-dev
#   libaprutil1-dev
#   libsqlite3-dev
#   zlib1g-dev
#   swig
#   python-pysqlite1.1

# from 1.10.0:

# options
#  --disable-keychain              Disable use of Mac OS KeyChain for auth credentials
#  --disable-googlemock            Do not use the Googlemock testing framework
#  --with-lz4=PREFIX|internal
#  --with-utf8proc=PREFIX|internal

./configure \
  --disable-keychain \
  --disable-googlemock \
  --with-lz4=internal \
  --with-utf8proc=internal \
  --with-swig=/usr


# make -j8        # < 2 min on dedi2 (8 cpus, 16 Gb RAM)
#   OR
# make -j4        # < 2 min on dedi4 (4 cpus, 8 Gb RAM)

# make -j8 check      # < ?? min on dedi2 (UNABLE ON DEDI2!!??)
#   OR
# make -j4 check      # < 66 min on dedi4

# make install
