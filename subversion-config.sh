#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Subversion."
  exit
fi

# Debian packages
#
#   python-pysqlite2
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
  --with-utf8proc=internal


# make -j8        # < 2 min on dedi2
# make check      # can't make it work

# make install
