#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run as root to install Openstreetmap prereq packages for Debian 10 Buster amd64"
    echo
    exit
fi

aptitude update

#  osm2pgsql \ # need v1.2.0+ # compiles from src fine
aptitude install \
  postgis \
  postgresql-contrib \
  libmapnik-dev \
  build-essential
  curl \
  unzip \
  gdal-bin \
  mapnik-utils \
  python3-yaml \
  python3-psycop2 \
  python3-requests \
  gdal-bin
  fonts-noto-cjk \
  fonts-noto-hinted \
  fonts-noto-unhinted \
  fonts-hanazono \
  ttf-unifont \
  mapnik-vector-tile \
  python3-mapnik

  # end of command list
