#!/bin/bash
# requires bash 3.2 (e.g., bash --version)
# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/
# run, as root, to set up rakudo on a Debian host

# Debian package requirements:
#   build-essential
#   time

# Note that an existing Perl 6 installation in $HOME/.rakudobrew may
# interfere with a successful installation of the Rakudo Star package.

# don't forget the needed bash functions
. ./bash-funcs.sh
# requires bash 3.2 (e.g., bash --version)
check_bash_version

ARCH=rakudo-2016.11.tar.gz
ARCHDIR=`get_archdir $ARCH`

#echo "ARCH: '$ARCH'";
#echo "ARCHDIR: '$ARCHDIR'";
#debug_exit 3

INSTDIR=/usr/local/rakudo.d
BINDIR=$INSTDIR/bin

GO=
TEST=
DEBUG=
YES=
UNK=

if [[ -z "$1" ]] ; then
    cat <<EOF
Usage: $0 go | [-test][-debug][-yes]

As root, sets up a new Rakudo installation using a tgz release
  from <http://rakudo.org/downloads/rakudo/>.

Start in a clean directory with the desired Rakudo archive.

Internal variables (and current values) which may be changed as
desired:

  ARCH    - '$ARCH'
  INSTDIR - '$INSTDIR'
  BINDIR  - '$BINDIR'

Options:

  -test    No commands are executed.
  -debug   Extra information is printed.
  -yes     Answers 'y' to all questions (DANGER)
EOF
  exit 0
fi

# get input vars first
for o in $@
do
    #echo "input var '$o'"
case $o in
    -g|g|-go|go)
    GO=1
    shift # past argument=value
    ;;
    -t|t|-test|test)
    TEST=1
    GO=1
    shift # past argument=value
    ;;
    -d|d|-debug|debug)
    DEBUG=1
    GO=1
    shift # past argument=value
    ;;
    -y|y|-yes|yes)
    YES=1
    GO=1
    shift # past argument=value
    ;;
    *)
    UNK=$o # unknown option
    shift # past argument=value
    ;;
esac
done

if [[ -n $DEBUG ]] ; then
    echo "GO    = '$GO'"
    echo "TEST  = '$TEST'"
    echo "YES   = '$YES'"
    echo "DEBUG = '$DEBUG'"
    echo "UNK   = '$UNK'"
fi

if [[ -n "$UNK" ]] ; then
    echo "FATAL:  Unknown option '$UNK'...exiting."
    exit 2
fi

if [[ -z $TEST  && $UID != "0" ]] ; then
  echo "You are not root!  Exiting...."
  exit
fi

echo "Unpack '$ARCH'?"
get_approval $YES

# ensure we have an INSTDIR
if [ ! -d $INSTDIR ] ; then
    echo "WARNING:  no dir '$INSTDIR' found...create?."
    get_approval
    if [[ -n $TEST ]] ; then
	echo "cmd: 'mkdir -p $INSTDIR'"
    else
	mkdir -p $INSTDIR
    fi
fi
if [[ -n $TEST ]] ; then
    echo "cmd: 'tar -xvzf $ARCH'"
else
    tar -xvzf $ARCH
fi



echo "Configuring: going to dir '$ARCHDIR'..."

# go to src dir ====================================
cd $ARCHDIR

# configure
CONF="perl Configure.pl --backend=moar --gen-moar --prefix=$INSTDIR"

echo "config cmd: '$CONF'"
echo "Configure?"
get_approval $YES
if [[ -n $TEST ]] ; then
    echo "cmd: '$CONF'"
else
    `echo time $CONF`
fi

# go to config dir ====================================
echo "Build?"
get_approval $YES
if [[ -n $TEST ]] ; then
    echo "cmd: 'echo time make'"
    echo "cmd: 'echo time make rakudo-test'"
else
    `echo time make`
    `echo time make rakudo-test`
fi

echo "Install?"
get_approval $YES
if [[ -n $TEST ]] ; then
    echo "cmd: 'echo time make install'"
else
    `echo time make install`
fi

# final message
cat <<HERE
Installation complete.  You need to place one or more
of installed rakudo bin directories in your path.  Here
is one way to do it: add the following lines into a
file named, say, /etc/profile.d/set-rakudo-paths.sh:

RAKDIR=$INSTDIR
P6B1=\$RAKDIR/bin
P6B2=\$RAKDIR/share/perl6/bin
P6B3=\$RAKDIR/share/perl6/site/bin
P6B4=\$RAKDIR/share/perl6/vendor/bin
PERL6BINDIRS=\$P6B1:\$P6B2:\$P6B3:\$P6B4
export PATH=\$PERL6BINDIRS:\$PATH
HERE

exit 0
