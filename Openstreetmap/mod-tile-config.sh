#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "Configures mod_tile using Apache in '/usr/local/apache2'."
  echo
  echo "Run from inside the mod_tile repo directory."
  echo
  echo "Installs to: '/usr/local/apache2/modules/mod_tile.so'."
  exit
fi

./autogen.sh
./configure \
    --with-apxs=/usr/local/apache2/bin/apxs

echo "============================="
echo " now run:"
echo "   make"
echo "   sudo make install"
echo "   sudo make install-mod_tile"
echo "============================="

#  Optional Features:
#    --disable-option-checking  ignore unrecognized --enable/--with options
#    --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
#    --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
#    --enable-silent-rules   less verbose build output (undo: "make V=1")
#    --disable-silent-rules  verbose build output (undo: "make V=0")
#    --enable-shared[=PKGS]  build shared libraries [default=yes]
#    --enable-static[=PKGS]  build static libraries [default=yes]
#    --enable-fast-install[=PKGS]
#                            optimize for fast installation [default=yes]
#    --enable-dependency-tracking
#                            do not reject slow dependency extractors
#    --disable-dependency-tracking
#                            speeds up one-time build
#    --disable-libtool-lock  avoid locking (might break parallel builds)
#    --disable-libmemcached  Build with libmemcached support [default=on]
#
#  Optional Packages:
#    --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
#    --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
#    --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
#                            both]
#    --with-aix-soname=aix|svr4|both
#                            shared library versioning (aka "SONAME") variant to
#                            provide on AIX, [default=aix].
#    --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
#    --with-sysroot[=DIR]    Search for dependent libraries within DIR (or the
#                            compiler's sysroot if not specified).
#    --with-libmapnik=[ARG]  use mapnik library [default=yes], optionally specify
#                            path to mapnik-config
#    --with-libcurl=PREFIX   look for the curl library in PREFIX/lib and headers
#                            in PREFIX/include
#    --with-apxs=PATH        path to Apache apxs
