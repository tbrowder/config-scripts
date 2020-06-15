#!/usr/bin/env bash

# must check for its existence:
APRPATH=/usr/local/apr

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Apache APR-UTIL for /usr/local."
  echo "  Expects Apr in '$APRPATH'."
  exit
fi

if [[ ! -d $APRPATH ]] ; then
    echo "FATAL:  Cannot find $APRPATH."
    exit
fi

#  Optional Features:
#    --disable-option-checking  ignore unrecognized --enable/--with options
#    --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
#    --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
#    --enable-layout=LAYOUT
#    --disable-util-dso      disable DSO build of modular components (crypto,
#                            dbd, dbm, ldap)
#
#  Optional Packages:
#    --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
#    --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
#    --with-apr=PATH         prefix for installed APR or the full path to
#                               apr-config
#    --with-apr-iconv=DIR    relative path to apr-iconv source
#    --with-crypto           enable crypto support
#    --with-openssl=DIR      specify location of OpenSSL
#    --with-nss=DIR          specify location of NSS
#    --with-commoncrypto=DIR specify location of CommonCrypto
#    --with-lber=library     lber library to use
#    --with-ldap-include=path  path to ldap include files with trailing slash
#    --with-ldap-lib=path    path to ldap lib file
#    --with-ldap=library     ldap library to use
#    --with-dbm=DBM          choose the DBM type to use.
#                            DBM={sdbm,gdbm,ndbm,db,db1,db185,db2,db3,db4,db4X,db5X,db6X}
#                            for some X=0,...,9
#    --with-gdbm=DIR         enable GDBM support
#    --with-ndbm=PATH        Find the NDBM header and library in `PATH/include'
#                            and `PATH/lib'. If PATH is of the form `HEADER:LIB',
#                            then search for header files in HEADER, and the
#                            library in LIB. If you omit the `=PATH' part
#                            completely, the configure script will search for
#                            NDBM in a number of standard places.
#    --with-berkeley-db=PATH Find the Berkeley DB header and library in
#                            `PATH/include' and `PATH/lib'. If PATH is of the
#                            form `HEADER:LIB', then search for header files in
#                            HEADER, and the library in LIB. If you omit the
#                            `=PATH' part completely, the configure script will
#                            search for Berkeley DB in a number of standard
#                            places.
#    --with-pgsql=DIR        specify PostgreSQL location
#    --with-mysql=DIR        enable MySQL DBD driver
#    --with-sqlite3=DIR      enable sqlite3 DBD driver
#    --with-sqlite2=DIR      enable sqlite2 DBD driver
#    --with-oracle-include=DIR
#                            path to Oracle include files
#    --with-oracle=DIR       enable Oracle DBD driver; giving ORACLE_HOME as DIR
#    --with-odbc=DIR         specify ODBC location
#    --with-expat=DIR        specify Expat location
#    --with-iconv=DIR        path to iconv installation

# may have to add paths to one or more of the options below
#    --with-apr=PATH         prefix for installed APR or the full path to
#    --with-pgsql=DIR        specify PostgreSQL location
#    --with-sqlite3=DIR      enable sqlite3 DBD driver
#    --with-berkeley-db=PATH Find the Berkeley DB header and library in
#    --with-gdbm=DIR         enable GDBM support
#    --with-ndbm=PATH        Find the NDBM header and library in `PATH/include'
./configure          \
--with-apr=$APRPATH  \
--with-openssl=OPENSSLDIR \
--with-crypto        \
--with-pgsql         \
--with-sqlite3       \
--with-berkeley-db   \
--with-gdbm          \
--with-ndbm

# make
# make install

# create file
#   /etc/ld.so.conf.d/apr.conf
# containing the line:
#   /usr/local/apr/lib
# then execute:
#   ldconfig
