#!/bin/bash

VER=5.2.0
REPO="https://github.com/gravitystorm/openstreetmap-carto"
FILE=v${VER}.tar.gz
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Gets version $VER of the osm carto style from '$REPO',"
    echo "  but you should check and update the VER number if there is a later version."
    echo
    exit
fi

# NOTE: Need the quotes around the URL:
curl -L -o $FILE "${REPO}/archive/${FILE}"
