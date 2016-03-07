#!/bin/bash

# make sure this points to the right source dir:
VER=2.4.18
LDIR=/usr/local/src
SRCDIR=${LDIR}/httpd-$VER

# use the latest gcc
GCCVER=5.2.0
GCCBINDIR=/usr/local/gcc/${GCCVER}/bin
CC=${GCCBINDIR}/gcc
CXX=${GCCBINDIR}/g++
CPP=${GCCBINDIR}/cpp

# NOTE: THIS CONFIGURATION IS WITH NO SYSTEM OPENSSL
#       AND IT USES THE LATEST INSTALLED APR AND APR-UTILS.

# see Ivan Ristics "Bulletproof SSL and TLS," p. 382
# using static openssl with Apache

SSLDIR=/opt/openssl

USAGE="Usage: $0 go"

if [[ ! -d $SRCDIR ]] ; then
  echo "ERROR:  No dir '$SRCDIR' found."
  exit
fi

if [[ -z $1 ]] ; then
  echo $USAGE
  echo "  Uses SRCDIR '$SRCDIR'."
  echo "  Uses SSL/TLS without FIPS."
  exit
fi

## APACHE HAS TO BE BUILT IN THE SOURCE DIR AT THE MOMENT
## make sure we're not in src dir
#CWD=`pwd`
#if [ "$SRCDIR" = "$CWD" ] ; then
#  echo "ERROR:  Current dir is src dir '$SRCDIR'."
#  echo "        You must use a build dir outside this directory."
#  exit
#fi

# See http://httpd.apache.org/ for detailed installation instructions.
#
# dependencies and requirements:
#
#   Deb packages:
#     ntp ntp-doc ntpdate
#     libtool libexpat1-dev libxml2-dev
#     lua and friends?
#
#   Source libraries:
#
#     From: http://www.openssl.org/
#       OpenSSL                     <latest>
#
#     From: http://www.pcre.org/
#       PCRE                        <latest>
#       Note: as root run ldconfig after installation.
#
#       ./configure
#        make
#        make check
#        sudo make install
#
#     From: https://apr.apache.org/
#       APR       (see below also)  <latest>
#       APR-Utils (see below also)  <latest>
#
#        ./configure
#        make
#        make check
#        sudo make install

# post installation:
#
#     From: http://code.google.com/p/modwsgi/ [need for Django]
#       mod_wsgi                    mod_wsgi-3.4.tar.gz
#
#     In /etc/ntp.conf make sure you have the US time servers.
#

# the Apache layout:
# <Layout Apache>
#     prefix:        /usr/local/apache2
#     exec_prefix:   ${prefix}
#     bindir:        ${exec_prefix}/bin
#     sbindir:       ${exec_prefix}/bin
#     libdir:        ${exec_prefix}/lib
#     libexecdir:    ${exec_prefix}/modules
#     mandir:        ${prefix}/man
#     sysconfdir:    ${prefix}/conf
#     datadir:       ${prefix}
#     installbuilddir: ${datadir}/build
#     errordir:      ${datadir}/error
#     iconsdir:      ${datadir}/icons
#     htdocsdir:     ${datadir}/htdocs
#     manualdir:     ${datadir}/manual
#     cgidir:        ${datadir}/cgi-bin
#     includedir:    ${prefix}/include
#     localstatedir: ${prefix}
#     runtimedir:    ${localstatedir}/logs
#     logfiledir:    ${localstatedir}/logs
#     proxycachedir: ${localstatedir}/proxy
# </Layout>

# lua >= 5.1      # will not use
# distcache?      # will not use
# ldap?           # will not use
# --with-crypto?  # yes!
# privileges?     # Solaris only

# note: build mod_wsgi after installing apache

#export LDFLAGS="-L/opt/openssl/lib"

# BUGS:
#   no pcre2 capability

# Note this line:
#    --with-openssl=/opt/openssl            \
# is required if there is NO system openssl.


# we build all modules for now (all shared except mod_ssl)
#export LDFLAGS="-L${SSLDIR}/lib"

#    --with-openssl=${SSLDIR}/lib

export LDFLAGS="-Wl,-rpath,${SSLDIR}/lib"
$SRCDIR/configure                          \
    --prefix=/usr/local/apache2            \
\
    --enable-ssl                           \
    --enable-ssl-staticlib-deps            \
    --enable-mods-static=ssl               \
    --with-ssl=${SSLDIR}                   \
\
    --enable-mods-shared=reallyall         \
    --with-perl                            \
    --with-python                          \
    --enable-layout=Apache                 \
    --with-pcre=/usr/local/bin/pcre-config \
    --without-ldap                         \
    --enable-session-crypto                \
    --enable-session \
    --with-crypto                \
    --with-openssl=${SSLDIR}

# make
# sudo make install
