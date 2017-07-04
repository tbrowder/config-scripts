#!/bin/bash

# make sure this points to the right source dir:
VER=2.4.25
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
#     lua and friends (5.2 for now)
#       liblua5.2-dev liblua5.2-0 lua5.2
#     libaprutil1-dbd-pgsql
#     libaprutil1-dbd-sqlite3
#     libaprutil1-dbd-ldap
#     libapr1-dev libapreq2-dev libaprutil1-dev lua-apr-dev
#     libapache2-mod-apreq2 lksctp-tools
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
#       Make sure you have APR and APR-Util already installed on your
#       system. If you don't, or prefer to not use the system-provided
#       versions, download the latest versions of both APR and
#       APR-Util from Apache APR, unpack them into
#
#         /httpd_source_tree_root/srclib/apr and
#         /httpd_source_tree_root/srclib/apr-util
#
#       (be sure the directory names do not have version numbers; for
#       example, the APR distribution must be under
#       /httpd_source_tree_root/srclib/apr/) and use ./configure's
#       --with-included-apr option. On some platforms, you may have to
#       install the corresponding -dev packages to allow httpd to
#       build against your installed copy of APR and APR-Util.
#
#
#      ../apache-config-no-fips.sh go
#      make [-jN]
#      sudo make install
#
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

# distcache?      # will not use
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
\
    --with-pgsql                           \
    --with-sqlite3                         \
\
    --with-python                          \
    --with-lua=/usr                        \
    --enable-layout=Apache                 \
    --with-pcre=/usr/local/bin/pcre-config \
    --with-ldap                            \
    --enable-session-crypto                \
    --enable-session \
    --with-crypto                \
    --with-openssl=${SSLDIR}

# make
# sudo make install
