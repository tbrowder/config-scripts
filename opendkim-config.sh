#!/usr/bin/env bash

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# make sure this points to the right source dir:
VER=
LDIR=/usr/local/src
SRCDIR=${LDIR}/emacs-$VER

USAGE="Usage: $0 go"

if [[ ! -d $SRCDIR ]] ; then
  echo "ERROR:  No dir '$SRCDIR' found."
  exit
fi

if [[ -z $1 ]] ; then
  echo $USAGE
  echo "  Uses SRCDIR '$SRCDIR'."
  exit
fi

# ensure we build outside the source dir
# make sure we're not in src dir
CWD=`pwd`
if [ "$SRCDIR" = "$CWD" ] ; then
  echo "ERROR:  Current dir is src dir '$SRCDIR'."
  echo "        You must use a build dir outside this directory."
  exit
fi

# dependencies and requirements:
# debian packages:
#   libgif-dev
#   libungif-bin
#   libmilter

$SRCDIR/configure \
    --with-lua

# make

# try it: execute:
#   src/emacs -Q

# all okay:

# sudo make install
# make clean
