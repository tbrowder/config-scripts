#!/usr/bin/env bash

# current as of:
CUR="2022-05-14"
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Confirms Apache2 and pre-reqs source with sha256sum data"
    echo " current as of ${CUR}"
    echo
    exit
fi

FILS="
  openssl-1.1.1o.tar.gz
  openssl-3.0.3.tar.gz
  httpd-2.4.53.tar.gz
  apr-1.7.0.tar.gz
  apr-util-1.6.1.tar.gz
"

for f in $FILS
do
    echo "Confirming '$f'"
    SHA="${f}.sha256"
    sha256sum -c $SHA
done
