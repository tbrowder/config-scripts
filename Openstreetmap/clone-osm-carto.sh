#!/bin/bash

VER=5.2.0
REPO="https://github.com/gravitystorm/openstreetmap-carto"
FILE=v${VER}.tar.gz
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Clones the Github repo of the osm carto style from '$REPO'."
    echo
    exit
fi

# NOTE: Need the quotes around the URL:
git clone "${REPO}/archive/${FILE}"
