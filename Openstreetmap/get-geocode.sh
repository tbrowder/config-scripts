#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Example single geocode request to provider 'Geocod.io'"
    echo
    exit
fi

MYAPIKEY=dummy

# NOTE: Need the quotes around the URL:
CMD='curl -o addr.json "https://api.geocod.io/v1.6/geocode?q=113+canterbury+circle,niceville,fl&api_key=$MYAPIKEY&limit=1"'
echo $CMD
