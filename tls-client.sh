#!/bin/bash

DOC=index
if [[ -z $1 ]] ; then
    echo "Usage: $0 <IP address> [<some document>]"
    echo
    echo "Gets the doc '$DOC' at IP unless another document is requested as the second arg."
    echo
    exit
fi

if [[ -n $2 ]] ; then
    DOC=$2
fi

echo "GET $DOC" | openssl s_client -connect ${1}:443 -servername $1
