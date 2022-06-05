#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run as root to install Apache2 prereq packages for Debian amd64"
    echo
    exit
fi

aptitude update

# note there must NOT be a space after the ending backslash on a line
aptitude install \
  apt-file \
  comerr-dev \
  fail2ban \
  krb5-multidev \
  libapr1-dev \
  libaprutil1-dev \
  libbrotli-dev \
  libcurl4-openssl-dev \
  libdb5.3-dev \
  libexpat1-dev  \
  libgdbm-compat-dev \
  libgdbm-dev \
  libidn2-dev \
  libjansson-dev \
  libldap2-dev \
  liblua5.2-0  \
  liblua5.2-dev  \
  libnghttp2-dev \
  libpcre3-dev \
  libpsl-dev \
  librtmp-dev \
  libsqlite3-dev \
  libssh2-1-dev \
  libsystemd-dev \
  libtool \
  libwebsocketpp-dev \
  libxml2-dev \
  lua5.2 \
  ntp \
  ntp-doc \
  ntpdate \
  postgresql-server-dev-all \
  pwgen \
  zlib1g-dev \
  libapr1-dev \
  libaprutil1-ldap \
  libaprutil1-dbd-pgsql \
  libaprutil1-dbd-sqlite3 \
  libaprutil1-dev \
  lksctp-tools \
  lua-ldap-dev \

# end of command list
