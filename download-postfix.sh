#!/bin/bash

# a regex to determine e or o
re="[0-9]+\.[0-9]+\.[0-9]+"
if [[ $1 =~ $re ]] ; then
    echo "$1 is an official release"
else 
    echo "$1 is an experimental release"
fi
exit

# set the latest known version
LATEST=3.3-20170730
# set the type (o - official, e - experimental)
TYPE=e

SITE="ftp://ftp.porcupine.org/mirrors/postfix-release"
if [[ $TYPE = 'e
SRCDIR=$SITE/official
SRCDIR=$SITE/experimental
KEY=$SITE/wietse.pgp

if [[ -z $1 ]] ; then
    echo "Usage: $0 <version> [v]"
    echo
    echo "Downloads postfix source and signature data from site '$SITE'."
    echo
    echo "The 'v' verifies only." 
    exit
fi

VER=$1
VERIFY=$2
 
SNAME=postfix-$VER.tar.tgz
GNAME=postfix-$VER.tar.gz.gpg2 
KNAME=wietse.pgp
SRC="$SRCDIR/postfix-$VER.tar.gz"
GPG="$SRCDIR/postfix-$VER.tar.gz.gpg2" 

if [[ -z $VERIFY ]] ; then

echo "Downloading src file '$SNAME'..."
curl $SRC -o $SNAME

echo "Downloading gpg file '$GNAME'..."
curl $GPG -o $GNAME 

echo "Downloading Wietse's key file '$KNAME'..."
curl $KEY -o $KNAME

# add it to key ring
gpg --import $KNAME
# delete it?

fi

echo "Verifying file '$SNAME' with sig '$GNAME'..."
gpg --verify $GNAME $SNAME
