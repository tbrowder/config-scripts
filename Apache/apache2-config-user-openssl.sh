#!/usr/bin/env bash

#1.1.1o

KNOWN_OPENSSL_VERS="
3.0.3
"

# NOTE: THIS CONFIGURATION IS FOR A USER-INSTALLED OPENSSL,
#       AND IT USES THE LATEST INSTALLED APR AND APR-UTILS.

# see Ivan Ristic's "Bulletproof SSL and TLS," p. 382
# using static openssl with Apache

USAGE="Usage: $0 <openssl version>"

APRPATH=/usr/local/apr

# use local apr and apr-util? uncomment below
# if [[ ! -d $APRPATH ]] ; then
#     echo "FATAL:  Apr and Apr-util dir '$APRPATH' doesn't exist."
#     exit
# fi

if [[ -z $1 ]] ; then
  echo $USAGE
  echo "  Uses SSL/TLS without FIPS."
  echo "  Builds httpd with openssl"
  echo "    from known versions: '$KNOWN_OPENSSL_VERS'"
  echo "    and the latest Apr and Apr-util"
  echo "    located in '$APRPATH'."
  echo
  echo "  After configuring run:"
  echo "    make"
  echo "    sudo make install"
  echo
  echo "  Some apache commands to be run as root:"
  echo "    apachectl -k graceful-stop"
  echo "    apachectl -k start"
  exit
fi

VER=$1
SSLDIR=/opt/openssl-$VER
# make sure openssl exists
if [[ ! -d $SSLDIR ]] ; then
    echo "FATAL:  openssl directory '$SSLDIR' doesn't exist."
    exit
fi

GOODVER=
for ver in $KNOWN_OPENSSL_VERS
do
    if [[ $1 = $ver ]] ; then
        GOODVER=$ver
    fi
done
if [[ -z $GOODVER ]] ; then
    echo "FATAL:  Openssl version $VER is not known."
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
#   Debian packages:
#     ntp ntp-doc ntpdate
#     libtool libexpat1-dev libxml2-dev
#     liblua5.2-dev liblua5.2-0 lua5.2
#     libpcre3-dev
#     libsystemd-dev
#     libwepsocketpp-dev
# libjannson-dev
# libnghttp2-dev
# libidn2-dev
# librtmp-dev
# libssh2-1-dev
# libpsl-dev
# krb5-multidev
# comerr-dev
# libldap2-dev

#
#   The following are NOT needed if APR is installed from source:
#     libaprutil1-dbd-pgsql
#     libaprutil1-dbd-sqlite3
#     libaprutil1-dbd-ldap
#     libapr1-dev libapreq2-dev libaprutil1-dev lua-apr-dev
#     libapache2-mod-apreq2 lksctp-tools
#
# post installation:
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

# we build all modules for now (all shared except mod_ssl)

#    --with-apr=$APRPATH                    \
#    --with-apr-util=$APRPATH               \
export LDFLAGS="-Wl,-rpath,${SSLDIR}/lib"
./configure                                \
    --prefix=/usr/local/apache2            \
\
    --enable-ssl                           \
    --enable-mods-static=ssl               \
    --enable-ssl-staticlib-deps            \
    --with-ssl=${SSLDIR}                   \
    --with-openssl=${SSLDIR}               \
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
    --with-ldap                            \
    --with-crypto                          \
    --enable-systemd                       \
    --enable-md                            \
    --enable-proxy                         \
    --enable-proxy-http2                   \
    --enable-http2                         \

# make depend [don't normally need this]

# make
# sudo make install
# apachectl -k graceful-stop
# apachectl -k start

#=============================================================
#  Optional Features:
#    --disable-option-checking  ignore unrecognized --enable/--with options
#    --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
#    --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
#    --enable-layout=LAYOUT
#    --enable-dtrace         Enable DTrace probes
#    --enable-hook-probes    Enable APR hook probes
#    --enable-exception-hook Enable fatal exception hook
#    --enable-load-all-modules
#                            Load all modules
#    --enable-maintainer-mode
#                            Turn on debugging and compile time warnings and load
#                            all compiled modules
#    --enable-debugger-mode  Turn on debugging and compile time warnings and turn
#                            off optimization
#    --enable-pie            Build httpd as a Position Independent Executable
#    --enable-modules=MODULE-LIST
#                            Space-separated list of modules to enable | "all" |
#                            "most" | "few" | "none" | "reallyall"
#    --enable-mods-shared=MODULE-LIST
#                            Space-separated list of shared modules to enable |
#                            "all" | "most" | "few" | "reallyall"
#    --enable-mods-static=MODULE-LIST
#                            Space-separated list of static modules to enable |
#                            "all" | "most" | "few" | "reallyall"
#    --disable-authn-file    file-based authentication control
#    --enable-authn-dbm      DBM-based authentication control
#    --enable-authn-anon     anonymous user authentication control
#    --enable-authn-dbd      SQL-based authentication control
#    --enable-authn-socache  Cached authentication control
#    --disable-authn-core    core authentication module
#    --disable-authz-host    host-based authorization control
#    --disable-authz-groupfile
#                            'require group' authorization control
#    --disable-authz-user    'require user' authorization control
#    --enable-authz-dbm      DBM-based authorization control
#    --enable-authz-owner    'require file-owner' authorization control
#    --enable-authz-dbd      SQL based authorization and Login/Session support
#    --disable-authz-core    core authorization provider vector module
#    --enable-authnz-ldap    LDAP based authentication
#    --enable-authnz-fcgi    FastCGI authorizer-based authentication and
#                            authorization
#    --disable-access-compat mod_access compatibility
#    --disable-auth-basic    basic authentication
#    --enable-auth-form      form authentication
#    --enable-auth-digest    RFC2617 Digest authentication
#    --enable-allowmethods   restrict allowed HTTP methods
#    --enable-isapi          isapi extension support
#    --enable-file-cache     File cache
#    --enable-cache          dynamic file caching. At least one storage
#                            management module (e.g. mod_cache_disk) is also
#                            necessary.
#    --enable-cache-disk     disk caching module
#    --enable-cache-socache  shared object caching module
#    --enable-socache-shmcb  shmcb small object cache provider
#    --enable-socache-dbm    dbm small object cache provider
#    --enable-socache-memcache
#                            memcache small object cache provider
#    --enable-socache-dc     distcache small object cache provider
#    --enable-so             DSO capability. This module will be automatically
#                            enabled unless you build all modules statically.
#    --enable-watchdog       Watchdog module
#    --enable-macro          Define and use macros in configuration files
#    --enable-dbd            Apache DBD Framework
#    --enable-bucketeer      buckets manipulation filter. Useful only for
#                            developers and testing purposes.
#    --enable-dumpio         I/O dump filter
#    --enable-echo           ECHO server
#    --enable-example-hooks  Example hook callback handler module
#    --enable-case-filter    Example uppercase conversion filter
#    --enable-case-filter-in Example uppercase conversion input filter
#    --enable-example-ipc    Example of shared memory and mutex usage
#    --enable-buffer         Filter Buffering
#    --enable-data           RFC2397 data encoder
#    --enable-ratelimit      Output Bandwidth Limiting
#    --disable-reqtimeout    Limit time waiting for request from client
#    --enable-ext-filter     external filter module
#    --enable-request        Request Body Filtering
#    --enable-include        Server Side Includes
#    --disable-filter        Smart Filtering
#    --enable-reflector      Reflect request through the output filter stack
#    --enable-substitute     response content rewrite-like filtering
#    --enable-sed            filter request and/or response bodies through sed
#    --disable-charset-lite  character set translation. Enabled by default only
#                            on EBCDIC systems.
#    --enable-charset-lite   character set translation. Enabled by default only
#                            on EBCDIC systems.
#    --enable-deflate        Deflate transfer encoding support
#    --enable-xml2enc        i18n support for markup filters
#    --enable-proxy-html     Fix HTML Links in a Reverse Proxy
#    --enable-brotli         Brotli compression support
#    --enable-http           HTTP protocol handling. The http module is a basic
#                            one that enables the server to function as an HTTP
#                            server. It is only useful to disable it if you want
#                            to use another protocol module instead. Don't
#                            disable this module unless you are really sure what
#                            you are doing. Note: This module will always be
#                            linked statically.
#    --disable-mime          mapping of file-extension to MIME. Disabling this
#                            module is normally not recommended.
#    --enable-ldap           LDAP caching and connection pooling services
#    --disable-log-config    logging configuration. You won't be able to log
#                            requests to the server without this module.
#    --enable-log-debug      configurable debug logging
#    --enable-log-forensic   forensic logging
#    --enable-logio          input and output logging
#    --enable-lua            Apache Lua Framework
#    --enable-luajit         Enable LuaJit Support
#    --disable-env           clearing/setting of ENV vars
#    --enable-mime-magic     automagically determining MIME type
#    --enable-cern-meta      CERN-type meta files
#    --enable-expires        Expires header control
#    --disable-headers       HTTP header control
#    --enable-ident          RFC 1413 identity check
#    --enable-usertrack      user-session tracking
#    --enable-unique-id      per-request unique ids
#    --disable-setenvif      basing ENV vars on headers
#    --disable-version       determining httpd version in config files
#    --enable-remoteip       translate header contents to an apparent client
#                            remote_ip
#    --enable-proxy          Apache proxy module
#    --enable-proxy-connect  Apache proxy CONNECT module. Requires
#                            --enable-proxy.
#    --enable-proxy-ftp      Apache proxy FTP module. Requires --enable-proxy.
#    --enable-proxy-http     Apache proxy HTTP module. Requires --enable-proxy.
#    --enable-proxy-fcgi     Apache proxy FastCGI module. Requires
#                            --enable-proxy.
#    --enable-proxy-scgi     Apache proxy SCGI module. Requires --enable-proxy.
#    --enable-proxy-fdpass   Apache proxy to Unix Daemon Socket module. Requires
#                            --enable-proxy.
#    --enable-proxy-wstunnel Apache proxy Websocket Tunnel module. Requires
#                            --enable-proxy.
#    --enable-proxy-ajp      Apache proxy AJP module. Requires --enable-proxy.
#    --enable-proxy-balancer Apache proxy BALANCER module. Requires
#                            --enable-proxy.
#    --enable-proxy-express  mass reverse-proxy module. Requires --enable-proxy.
#    --enable-proxy-hcheck   reverse-proxy health-check module. Requires
#                            --enable-proxy and --enable-watchdog.
#    --enable-session        session module
#    --enable-session-cookie session cookie module
#    --enable-session-crypto session crypto module
#    --enable-session-dbd    session dbd module
#    --enable-slotmem-shm    slotmem provider that uses shared memory
#    --enable-slotmem-plain  slotmem provider that uses plain memory
#    --enable-ssl            SSL/TLS support (mod_ssl)
#    --enable-ssl-staticlib-deps
#                            link mod_ssl with dependencies of OpenSSL's static
#                            libraries (as indicated by "pkg-config --static").
#                            Must be specified in addition to --enable-ssl.
#    --enable-optional-hook-export
#                            example optional hook exporter
#    --enable-optional-hook-import
#                            example optional hook importer
#    --enable-optional-fn-import
#                            example optional function importer
#    --enable-optional-fn-export
#                            example optional function exporter
#    --enable-dialup         rate limits static files to dialup modem speeds
#    --enable-static-support Build a statically linked version of the support
#                            binaries
#    --enable-static-htpasswd
#                            Build a statically linked version of htpasswd
#    --enable-static-htdigest
#                            Build a statically linked version of htdigest
#    --enable-static-rotatelogs
#                            Build a statically linked version of rotatelogs
#    --enable-static-logresolve
#                            Build a statically linked version of logresolve
#    --enable-static-htdbm   Build a statically linked version of htdbm
#    --enable-static-ab      Build a statically linked version of ab
#    --enable-static-checkgid
#                            Build a statically linked version of checkgid
#    --enable-static-htcacheclean
#                            Build a statically linked version of htcacheclean
#    --enable-static-httxt2dbm
#                            Build a statically linked version of httxt2dbm
#    --enable-static-fcgistarter
#                            Build a statically linked version of fcgistarter
#    --enable-http2          HTTP/2 protocol handling in addition to HTTP
#                            protocol handling. Implemented by mod_http2. This
#                            module requires a libnghttp2 installation. See
#                            --with-nghttp2 on how to manage non-standard
#                            locations. This module is usually linked shared and
#                            requires loading.
#    --enable-nghttp2-staticlib-deps
#                            link mod_http2 with dependencies of libnghttp2's
#                            static libraries (as indicated by "pkg-config
#                            --static"). Must be specified in addition to
#                            --enable-http2.
#    --enable-proxy-http2    HTTP/2 proxy module. This module requires a
#                            libnghttp2 installation. See --with-nghttp2 on how
#                            to manage non-standard locations. Also requires
#                            --enable-proxy.
#    --enable-lbmethod-byrequests
#                            Apache proxy Load balancing by request counting
#    --enable-lbmethod-bytraffic
#                            Apache proxy Load balancing by traffic counting
#    --enable-lbmethod-bybusyness
#                            Apache proxy Load balancing by busyness
#    --enable-lbmethod-heartbeat
#                            Apache proxy Load balancing from Heartbeats
#    --enable-mpms-shared=MPM-LIST
#                            Space-separated list of MPM modules to enable for
#                            dynamic loading. MPM-LIST=list | "all"
#    --enable-unixd          unix specific support
#    --enable-privileges     Per-virtualhost Unix UserIDs and enhanced security
#                            for Solaris
#    --enable-heartbeat      Generates Heartbeats
#    --enable-heartmonitor   Collects Heartbeats
#    --enable-dav            WebDAV protocol handling. --enable-dav also enables
#                            mod_dav_fs
#    --disable-status        process/thread monitoring
#    --disable-autoindex     directory listing
#    --enable-asis           as-is filetypes
#    --enable-info           server information
#    --enable-suexec         set uid and gid for spawned processes
#    --enable-cgid           CGI scripts. Enabled by default with threaded MPMs
#    --enable-cgi            CGI scripts. Enabled by default with non-threaded
#                            MPMs
#    --enable-dav-fs         DAV provider for the filesystem. --enable-dav also
#                            enables mod_dav_fs.
#    --enable-dav-lock       DAV provider for generic locking
#    --enable-vhost-alias    mass virtual hosting module
#    --enable-negotiation    content negotiation
#    --disable-dir           directory request handling
#    --enable-imagemap       server-side imagemaps
#    --enable-actions        Action triggering on requests
#    --enable-speling        correct common URL misspellings
#    --enable-userdir        mapping of requests to user-specific directories
#    --disable-alias         mapping of requests to different filesystem parts
#    --enable-rewrite        rule based URL manipulation
#    --enable-v4-mapped      Allow IPv6 sockets to handle IPv4 connections
#
#  Optional Packages:
#    --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
#    --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
#    --with-included-apr     Use bundled copies of APR/APR-Util
#    --with-apr=PATH         prefix for installed APR or the full path to
#                               apr-config
#    --with-apr-util=PATH    prefix for installed APU or the full path to
#                               apu-config
#    --with-pcre=PATH        Use external PCRE library
#    --with-port=PORT        Port on which to listen (default is 80)
#    --with-sslport=SSLPORT  Port on which to securelisten (default is 443)
#    --with-distcache=PATH   Distcache installation directory
#    --with-z=PATH           use a specific zlib library
#    --with-libxml2=PATH     location for libxml2
#    --with-brotli=PATH      Brotli installation directory
#    --with-lua=PATH         Path to the Lua 5.3/5.2/5.1 prefix
#    --with-ssl=PATH         OpenSSL installation directory
#    --with-nghttp2=PATH     nghttp2 installation directory
#    --with-mpm=MPM          Choose the process model for Apache to use by
#                            default. MPM={event|worker|prefork|winnt} This will
#                            be statically linked as the only available MPM
#                            unless --enable-mpms-shared is also specified.
#    --with-module=module-type:module-file
#                            Enable module-file in the modules/<module-type>
#                            directory.
#    --with-program-name     alternate executable name
#    --with-suexec-bin       Path to suexec binary
#    --with-suexec-caller    User allowed to call SuExec
#    --with-suexec-userdir   User subdirectory
#    --with-suexec-docroot   SuExec root directory
#    --with-suexec-uidmin    Minimal allowed UID
#    --with-suexec-gidmin    Minimal allowed GID
#    --with-suexec-logfile   Set the logfile
#    --with-suexec-safepath  Set the safepath
#    --with-suexec-umask     umask for suexec'd process
