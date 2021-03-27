#!/usr/bin/env bash

# current as of 2021-03-26
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Downloads Apache2 and pre-reqs source and sha256sum data"
    echo " current as of 2021-03-26"
    echo
    exit
fi

FILS="
https://www.openssl.org/source/openssl-1.1.1k.tar.gz
https://www.openssl.org/source/openssl-1.1.1k.tar.gz.sha256

https://downloads.apache.org//httpd/httpd-2.4.46.tar.gz
https://downloads.apache.org/httpd/httpd-2.4.46.tar.gz.sha256

https://downloads.apache.org//apr/apr-1.7.0.tar.gz
https://downloads.apache.org/apr/apr-1.7.0.tar.gz.sha256

https://downloads.apache.org//apr/apr-util-1.6.1.tar.gz
https://downloads.apache.org/apr/apr-util-1.6.1.tar.gz.sha256
"

for f in $FILS
do 
    echo "Downloading '$f'"
    curl $f -O
done

