#!/usr/bin/env bash

# cmake intructions:
#
#   in the source dir, create a buildir
#   cd to the builddir
#   execute:
#     cmake [options] ..
#
#   where desired options are:
#
#     -DCMAKE_INCLUDE_PATH=/path/to/libfoo/include
#     -DCMAKE_LIBRARY_PATH=/path/to/libfoo/lib
#
#   make && make check && make install

cmake \
    -DCMALE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu/cmake/Qt5Core \
    -DPOPPLER_CPP_INCLUDE_DIR=/usr/include/poppler/qt5 \
    -DPOPPLER_INCLUDE_DIR=/usr/include/poppler/qt5 \
    ..


#-DQt5Core_DIR=/usr/local/Qt/5.11.1/gcc_64/lib/cmake/Qt5Core \
#-DQt5Widgets_DIR=/usr/local/Qt/5.11.1/gcc_64/lib/cmake/Qt5Widgets \
#..

exit

# requirements for 1.5+
#
# Install the below packages BEFORE running CMake or compiling Scribus:
#
# Requirements (* - installed):
#   Qt >= 5.5.0 (Scribus has specific code requiring Qt 5.5.0,
#     not Qt 5.4.x or before)
#  *Freetype >= 2.1.7 (2.3.x strongly recommended)
#  *cairo >= 1.14.x
#  *libtiff >= 3.6.0
#  *LittleCMS (liblcms) >= 2.0 (2.1+ recommended)
#  *libjpeg (depending on how Qt is packaged)
#  *harfbuzz = > 0.9.42
#  *libicu
#
# Recommended (* - installed):
#  *CUPS
#  *Fontconfig >= 2.0
#  *LibXML2 >= 2.6.0
#  *GhostScript >= 8.0 (9.0+ or greater preferred)
#  *Python >= 2.3
#  *py-tkinter for the font sampler script
#  *python-imaging for the font sampler preview
#  *pkg-config (to assist finding other libraries)
#  *hunspell for the spell checker
#  *podofo - 0.7.0+ for enhanced Illustrator AI/EPS import, svn versions
#  *boost and boost-devel
#  *GraphicsMagick++
#
# If any recommended libraries (and their dev/devel packages or headers)
# are not installed, some features will be disabled by cmake. If you
# later install any of these dependencies, you will have to re-run cmake
# and re-compile Scribus before the features are enabled.
#
# other prereqs:
#   libzmf-dev >= 0.0
#   libqxp-dev >= 0.0

# WIP ...
KNOWN_VERS="1.1.0e 1.1.0f"
if [ -z "$1" ] ; then
  echo "Usage: $0 <openssl version>"
  echo
  echo "  Configures openssl source (without FIPS)"
  echo "    from known versions: '$KNOWN_VERS'"
  echo "    and installs it into directory"
  echo "    '/opt/openssl-<version>'."
  echo "  Note this script is designed to be in the directory"
  echo "    above the source directory and called from within"
  echo "    that directory which should be named:"
  echo "    'openssl-<version>'"
  echo
  exit
fi

VER=$1
GOODVER=
for ver in $KNOWN_VERS
do
    if [[ $1 = $ver ]] ; then
        GOODVER=$ver
    fi
done
if [[ -z $GOODVER ]] ; then
    echo "FATAL:  Openssl version $VER is not known."
    exit
fi

SSLDIR=/opt/openssl-$VER

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# see Ivan Ristics "Bulletproof SSL and TLS," p. 316

# openssl (no FIPS) ================
# we must use the shared library for some Apache friends
# do NOT use patented algorithms without permission:

# use package zlib1g-dev

# where are we?
SRCDIR=openssl-$VER
INSRCDIR="../$SRCDIR"
if [[ -d $INSRCDIR ]] ; then
    echo "Working in proper dir '$INSRCDIR'..."
elif [[ -d $SRCDIR ]] ; then
    echo "You are in the directory above dir '$SRCDIR'."
    echo "You must cd into it to execute this script."
    exit
else
    echo "Source directory '$SRCDIR' cannot be found."
    exit
fi

./config \
    no-ec2m                         \
    no-rc5                          \
    no-idea                         \
    threads                         \
    zlib-dynamic                    \
    shared                          \
    --prefix=${SSLDIR}              \
    --openssldir=${SSLDIR}          \
    enable-ec_nistp_64_gcc_128

# should be finished with building the makefils
echo
echo "===================================================="
echo "Now execute 'make && make test && sudo make install'"

# make depend [don't normally need this]
# make
# make test
# sudo make install
# make clean

# create file
#   /etc/ld.so.conf.d/openssl.conf
# containing the line:
#   /opt/openssl-<version>/lib
#   (ensure there is only ONE file pointing to ONE openssl version)
# then execute:
#   ldconfig

# make uninstall
