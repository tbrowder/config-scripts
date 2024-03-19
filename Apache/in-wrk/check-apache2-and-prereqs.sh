#!/usr/bin/env bash

# IMPORTANT DO THIS IN RAKU BECAUSE OF OPENSSL PROBLEM WITH SHA256 FORMAT:
#   IT CURRENTLY DOESN'T CONTAIN THE FILENAME THAT YIELDED THE HASH
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Checks sha256sums of Apache2 and pre-reqs source tgz files"
    echo
    exit
fi

FILS="
openssl-1.1.1g.tar.gz.sha256
httpd-2.4.43.tar.gz.sha256
apr-1.7.0.tar.gz.sha256
apr-util-1.6.1.tar.gz.sha256
"

for f in $FILS
do 
    #echo "Checking sha256sum '$f'"
    #sha256sum --check $f 
    sha256sum --check --strict $f 
done

