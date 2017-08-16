#!/bin/bash

# make sure this points to the right source dir
VER=3.2.0
SSLVER=1.1.0f
LDIR=/usr/local/src
SRCDIR=${LDIR}/postfix-${VER}
SSLDIR=/opt/openssl-${SSLVER}

if [ -z $1 ] ; then
  echo "Usage: $0 go"
  echo "Uses SRCDIR '$SRCDIR'"
  exit
fi

if [ ! -d $SRCDIR ] ; then
  echo "ERROR:  No dir '$SRCDIR' found."
  exit
fi

if [ ! -d $SSLDIR ] ; then
  echo "ERROR:  No dir '$SSLDIR' found."
  exit
fi

# uses weird make system
#   debian packages needed:
#     libdb-dev
#     libicu-dev
#

# uses current openssl in /opt/openssl-n.n.ny
# add current TLS handling?? YES
# add current Cyrus SASL library??
# if so, add some value to the SASL variable
SASL=

make tidy

if [[ -z $SASL ]] ; then
  # DON'T use SASL
  make makefiles CCARGS="-DUSE_TLS \
    -I${SSLDIR}/include" \
    AUXLIBS="-L/usr/local/lib -L${SSLDIR}/lib -Wl,-rpath=${SSLDIR}/lib -lssl -lcrypto"
else
  # yes, use SASL
  make makefiles CCARGS="-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DUSE_TLS \
    -I${SSLDIR}/include" \
    -I/usr/local/include/sasl \
    AUXLIBS="-L/usr/local/lib -lsal2 -L${SSLDIR}/lib -Wl,-rpath=${SSLDIR}/lib -lssl -lcrypto"

fi


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
echo "  \$ sudo make upgrade"
echo "  \$   (requires an existing /etc/postfix/main.cf)"
echo "======================"
