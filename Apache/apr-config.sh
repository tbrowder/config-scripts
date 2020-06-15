#!/usr/bin/env bash

# use downloaded and installed
#   openssl in /usr/local

# NOW INSTALL APRUTIL

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "Configures Apache APR for /usr/local."
  echo 
  echo "Note this MUST be installed before APR-UTIL."
  exit
fi

./configure
 
echo "========================="
echo " now run:"
echo "   make"
echo "   make test"
echo "   sudo make install"
echo "   make distclean"
echo "========================="

#  Optional Features:
#    --disable-option-checking  ignore unrecognized --enable/--with options
#    --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
#    --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
#    --enable-layout=LAYOUT
#    --enable-experimental-libtool Use experimental custom libtool
#    --enable-shared[=PKGS]  build shared libraries [default=yes]
#    --enable-static[=PKGS]  build static libraries [default=yes]
#    --enable-fast-install[=PKGS]
#                            optimize for fast installation [default=yes]
#    --disable-libtool-lock  avoid locking (might break parallel builds)
#    --enable-debug          Turn on debugging and compile time warnings
#    --enable-maintainer-mode  Turn on debugging and compile time warnings
#    --enable-profile        Turn on profiling for the build (GCC)
#    --enable-pool-debug[=yes|no|verbose|verbose-alloc|lifetime|owner|all]    Turn on pools debugging
#    --enable-malloc-debug   Switch on malloc_debug for BeOS
#    --disable-lfs           Disable large file support on 32-bit platforms
#    --enable-nonportable-atomics  Use optimized atomic code which may produce nonportable binaries
#    --enable-threads        Enable threading support in APR.
#    --enable-posix-shm      Use POSIX shared memory (shm_open) if available
#    --enable-allocator-uses-mmap    Use mmap in apr_allocator instead of malloc
#    --enable-allocator-guard-pages  Use guard pages in apr_allocator
#                                    (implies --enable-allocator-uses-mmap)
#    --enable-pool-concurrency-check Check for concurrent usage of memory pools
#    --disable-dso           Disable DSO support
#    --enable-other-child    Enable reliable child processes
#    --disable-ipv6          Disable IPv6 support in APR.
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
#    --with-installbuilddir=DIR location to store APR build files (defaults to '${datadir}/build')
#    --without-libtool       avoid using libtool to link the library
#    --with-efence[=DIR]     path to Electric Fence installation
#    --with-valgrind[=DIR]   Enable code to teach valgrind about apr pools
#                            (optionally: set path to valgrind headers)
#    --with-sendfile         Override decision to use sendfile
#    --with-egd[=DIR]        use EGD-compatible socket
#    --with-devrandom[=DEV]  use /dev/random or compatible [searches by default]
