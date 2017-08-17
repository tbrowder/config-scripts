#!/bin/bash
echo "this file ($0) needs work"; exit


SITE="ftp://ftp.porcupine.org/mirrors/postfix-release"
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
