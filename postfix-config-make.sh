#!/bin/bash

# make sure this points to the right source dir
VER=3.1.0
LDIR=/usr/local/src
SRCDIR=${LDIR}/postfix-${VER}

if [ -z $1 ] ; then
  echo "Usage: $0 go"
  echo "Uses SRCDIR '$SRCDIR'"
  exit
fi

if [ ! -d $SRCDIR ] ; then
  echo "ERROR:  No dir '$SRCDIR' found."
  exit
fi

# uses weird make system
#   debian packages needed:
#     libdb-dev
#     libicu-dev
#
# add current Cyrus SASL library?? YES
# add current TLS handling?? YES
make tidy
make makefiles CCARGS="-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DUSE_TLS \
  -I/usr/local/include/sasl -I/opt/openssl/include" \
  AUXLIBS="-L/usr/local/lib -lsasl2 -L/opt/openssl/lib -lssl -lcrypto"

# If at any time in the build process you get messages like: "make:
# don't know how to ..." you should be able to recover by running the
# following command from the Postfix top-level directory:
#
#   $ make -f Makefile.init makefiles

# cleanup command
#
#   $ make tidy
# main build command:
#   make
echo "======================"
echo "Now run:"
echo "  \$ make [-j N]"
echo "  \$ sudo make upgrade (requires an existing /etc/postfix/main.cf)"
echo "======================"



