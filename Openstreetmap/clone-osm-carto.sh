#!/bin/bash

REPO="https://github.com/gravitystorm/openstreetmap-carto"
if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Clones the Github repo of the osm carto style from '$REPO'."
    echo
    exit
fi

git clone $REPO
