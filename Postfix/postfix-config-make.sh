#!/usr/bin/env bash

# make sure this points to the desired source dir
VER=3.3-20170730
#VER=3.2.2
LDIR=/usr/local/src
SRCDIR=${LDIR}/postfix-${VER}

# we use the latest OPENSSL from openssl.org =====================
SSLVER=1.1.0f
SSLDIR=/opt/openssl-${SSLVER}

if [ -z $1 ] ; then
    echo "Usage: $0 go"
    echo
    echo "  Builds a Makefile for postfix version '$VER'."
    echo
    echo "  Note this script is designed to be in the directory"
    echo "    above the source directory and called from within"
    echo "    that directory which should be named:"
    echo "    '$SRCDIR'"
    echo
    echo "  Note also we use openssl version '$SSLVER'."
    echo
    exit
fi

if [ ! -d $SRCDIR ] ; then
  echo "ERROR:  No postfix src dir '$SRCDIR' found."
  exit
fi

#if [ ! -d $SSLDIR ] ; then
#  echo "ERROR:  No openssl dir '$SSLDIR' found."
#  exit
#fi

# where are we?
LSRCDIR=postfix-$VER
INSRCDIR="../$LSRCDIR"
if [[ -d $INSRCDIR ]] ; then
    echo "Working in proper dir '$INSRCDIR'..."
elif [[ -d $LSRCDIR ]] ; then
    echo "You are in the directory above dir '$LSRCDIR'."
    echo "You must cd into it to execute this script."
    exit
else
    echo "Source directory '$LSRCDIR' cannot be found."
    exit
fi

# uses weird make system
#   debian packages needed:
#     libdb5-dev
#     libicu-dev
#

# uses current openssl in /opt/openssl-n.n.ny
# add current TLS handling?? YES
# add current Cyrus SASL library??
# if so, add some value to the SASL variable
SASL=

make tidy

TLSARGS=
TLSLIBS=
SASLARGS=
SASLLIBS=
if [[ -z $SASL ]] ; then
    # DON'T use SASL
    make makefiles CCARGS="-DUSE_TLS -DNO_IP_CYRUS_SASL_AUTH -I${SSLDIR}/include" \
    	 AUXLIBS="-L${SSLDIR}/lib -Wl,-rpath=${SSLDIR}/lib -lssl -lcrypto"
else
    # yes, use SASL
    make makefiles CCARGS="-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DUSE_TLS -I/usr/local/include/sasl -I${SSLDIR}/include" \
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
