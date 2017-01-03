#!/bin/bash
INSTDIR=/usr/local/rakudo.d

if [[ -z "$1" ]] ; then
    cat <<EOF
Usage: $0 go 

Configures rakudo for installation in directory:

  $INSTDIR

EOF
  exit 0
fi

# configure
perl Configure.pl --backend=moar --gen-moar --prefix=$INSTDIR
