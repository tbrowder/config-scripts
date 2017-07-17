#!/bin/bash

USAGE="Usage: $0 go"

INSTDIR=/opt/rakudo

if [[ -z $1 ]] ; then
  echo $USAGE
  exit
fi

perl Configure.pl --backend=moar --gen-moar --prefix=$INSTDIR

# make
# make test
# sudo make install
