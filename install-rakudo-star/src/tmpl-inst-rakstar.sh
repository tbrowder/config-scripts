#!/bin/bash
# requires bash 3.2 (e.g., bash --version)
# the source for this file (and support files) is in:
#   https://github.com/tbrowder/config-scripts/
# run, as root, to set up the latest Rakudo Star on a Debian host

# Debian package requirements:
#   build-essential
#   time
#   git

# Note that an existing Perl 6 installation in $HOME/.rakudobrew may
# interfere with a successful installation of the Rakudo Star package.
# The default installation directory is partially removed to ensure
# the current nqp and moarvm are built along with Perl 6.

#=begin insert ./bash-funcs.sh
# don't forget to source the needed bash functions
. ./bash-funcs.sh
#=end insert bash-funcs.sh

# requires bash 3.2 (e.g., bash --version)
check_bash_version

INSTDIR=/opt/rakudo.d
BINDIR=$INSTDIR/bin

GO=
TEST=
DEBUG=
YES=
UNK=

if [[ -z "$1" ]] ; then
    cat <<EOF
Usage: $0 go | [-test][-debug][-yes]

Run by the owner of '$INSTDIR', sets up a new Rakudo Star
  installation using a tgz release from
  <http://rakudo.org/latest/star/source>.

Start in the unpacked source archive directory with this script in
the parent directory and run it like this:
  ../a clean directory with no other files but this script.

Internal variables (and current values) which may be changed as
desired:

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

# restict to root?
#if [[ -z $TEST  && $UID != "0" ]] ; then
#  echo "You are not root!  Exiting...."
#  exit
#fi

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

echo "Configuring..."

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

FILE="perl6paths.source"

# final message
cat > $FILE <<HERE
RAKDIR=$INSTDIR
P6B1=\$RAKDIR/bin
P6B2=\$RAKDIR/share/perl6/bin
P6B3=\$RAKDIR/share/perl6/site/bin
P6B4=\$RAKDIR/share/perl6/vendor/bin
PERL6BINDIRS=\$P6B1:\$P6B2:\$P6B3:\$P6B4
export PATH=\$PERL6BINDIRS:\$PATH
HERE

# final message
cat <<HERE
Installation complete.  You need to place one or more
of the newly installed rakudo bin directories in your
path.  Here is one way to do it: add the following lines
in your '.bash_aliases' file:

RAKDIR=$INSTDIR
P6B1=\$RAKDIR/bin
P6B2=\$RAKDIR/share/perl6/bin
P6B3=\$RAKDIR/share/perl6/site/bin
P6B4=\$RAKDIR/share/perl6/vendor/bin
PERL6BINDIRS=\$P6B1:\$P6B2:\$P6B3:\$P6B4
export PATH=\$PERL6BINDIRS:\$PATH
HERE

echo
echo "Those lines have been placed in file '$FILE' for sourcing,"
echo "  referencing, or copying into your '.bash_aliases' file."

exit 0
