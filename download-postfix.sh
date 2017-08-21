#!/usr/bin/env bash

# set the latest known or desirable version
#LATEST=3.2.2
LATEST=3.3-20170730

SITE="ftp://ftp.porcupine.org/mirrors/postfix-release"
if [[ -z $1 ]] ; then
    echo "Usage: $0 go | <version> [v]"
    echo
    echo "Downloads postfix source and signature data from site '$SITE'."
    echo
    echo "The 'go' uses version '$LATEST', or you can choose another version."
    echo "The 'v' verifies only."
    echo
    exit
fi

if [[ $1 =~ "g" ]] ; then
    VER=$LATEST
    #echo "first arg ($1) is 'go'"
else
    VER=$1
    #echo "first arg ($1) should be a version"
fi
#echo "debug exit"; exit

VERIFY=$2

# a regex to determine e or o
re="[0-9]+\.[0-9]+\.[0-9]+"
if [[ $VER =~ $re ]] ; then
    echo "$VER is an official release"
    SRCDIR=$SITE/official
else
    echo "$VER is an experimental release"
    SRCDIR=$SITE/experimental
fi

SNAME=postfix-$VER.tar.gz
GNAME="${SNAME}.gpg2"
KNAME=wietse.pgp

SRC="$SRCDIR/$SNAME"
GPG="$SRCDIR/$GNAME"
KEY="$SITE/$KNAME"

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
