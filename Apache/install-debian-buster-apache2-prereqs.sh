#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run as root to install Apache2 prereq packages for Debian 10 Buster amd64"
    echo
    exit
fi

aptitude update

aptitude install \
  ntp  \
  ntp-doc  \
  ntpdate \
  libtool  \
  libexpat1-dev  \
  libxml2-dev \
  liblua5.2-dev  \
  liblua5.2-0  \
  lua5.2 \
  libpcre3-dev \
  libsystemd-dev \
  libwebsocketpp-dev \
  libjansson-dev \
  libnghttp2-dev \
  libidn2-dev \
  librtmp-dev \
  libssh2-1-dev \
  libpsl-dev \
  krb5-multidev \
  comerr-dev \
  libldap2-dev \
  libcurl4-openssl-dev \
  fail2ban \
  apt-file \
  libsqlite3-dev \
  libgdbm-compat-dev \
  libgdbm-dev \
  libdb5.3-dev \
  postgresql-server-dev-all \
  pwgen

# end of command list
