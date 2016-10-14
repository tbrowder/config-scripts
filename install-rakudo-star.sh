#!/bin/bash
# requires bash 3.2 (e.g., bash --version)
# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/
# run, as root, to set up rakudo on a Debian host

# don't forget the needed bash functions
. ./bash-funcs.sh
# requires bash 3.2 (e.g., bash --version)
check_bash_version

ARCH=rakudo-star-2016.07.tar.gz
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
  from <http://rakudo.org/downloads/star>.

Start in a clean directory with the desired Rakudo Star archive.

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
    echo "input var '$o'"
case $o in
    -g|g|-go)
    GO=1
    shift # past argument=value
    ;;
    -t|t|-test)
    TEST=1
    GO=1
    shift # past argument=value
    ;;
    -d|d|-debug)
    DEBUG=1
    GO=1
    shift # past argument=value
    ;;
    -y|y|-yes)
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

#if [[ -z $TEST  && $UID != "0" ]] ; then
#  echo "You are not root!  Exiting...."
#  exit
#fi

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
pushd `pwd`
cd $ARCHDIR

# configure
CONF="perl Configure.pl --backend=moar --gen-moar --prefix=$INSTDIR"

echo "config cmd: '$CONF'"
echo "Configure?"
get_approval $YES
if [[ -n $TEST ]] ; then
    echo "cmd: '$CONF'"
else
`echo $CONF`
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
Installation complete.  Put the following lines in your environment:


HERE

exit 0
