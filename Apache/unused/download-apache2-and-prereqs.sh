#!/usr/bin/env bash

# current as of:
CUR="2022-05-14"
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Downloads Apache2 and pre-reqs source and sha256sum data"
    echo " current as of ${CUR}"
    echo
    exit
fi

FILS="
  https://www.openssl.org/source/openssl-3.0.3.tar.gz
  https://www.openssl.org/source/openssl-3.0.3.tar.gz.sha256
  https://www.openssl.org/source/openssl-3.0.3.tar.gz.asc
  https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz
  https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz.sha512
  https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz.asc
"

for f in $FILS
do
    echo "Downloading '$f'"
    curl $f -O
done
