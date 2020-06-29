#!/usr/bin/env bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go [c | b | i] # <== config | build | install"
    echo
    echo "Unpacks Apache2 and pre-reqs source, configures,"
    echo "   builds, tests, and installs them."
    echo
    exit
fi

EXE=
if [[ -n $2 ]] ; then
    EXE=yes
fi

FILS="
openssl-1.1.1g
httpd-2.4.43
apr-1.7.0
apr-util-1.6.1
"

for f in $FILS
do 
    echo "Working '$f'"
    if [[ -d $f ]] ; then
        echo "  Dir $f already exists..."
    else 
        echo "  Unpacking $f.tar.gz..."
        tar -xvzf $f.tar.gz
    fi
done

CWD=$(pwd)
#echo "DEBUG: curr dir is: '$CWD'"
#echo "DEBUG: value of EXE is: '$EXE'"
#exit

# openssl is first
cd openssl-1.1.1g
../openssl-config-no-fips.sh 1.1.1g
CMD="make && make test && sudo make install"
echo "  Next command is: $CMD"
if [[ -n $EXE ]] ; then
    echo "  Executing the command..."
    $CMD
else 
    echo "  Not executing the command."
fi
cd $CWD

# second is Apr
cd apr-1.7.0
../apr-config.sh go
CMD="make && make test && sudo make install"
echo "  Next command is: $CMD"
if [[ -n $EXE ]] ; then
    echo "  Executing the command..."
    $CMD
else 
    echo "  Not executing the command."
fi
cd $CWD

# third is Apr-util
cd apr-util-1.6.1
../apr-util-config.sh go
CMD="make && make test && sudo make install"
echo "  Next command is: $CMD"
if [[ -n $EXE ]] ; then
    echo "  Executing the command..."
    $CMD
else 
    echo "  Not executing the command."
fi
cd $CWD

# last is httpd
cd httpd-2.4.43
../apache2-config-user-openssl.sh 1.1.1g
CMD="make && sudo make install"
echo "  Next command is: $CMD"
if [[ -n $EXE ]] ; then
    echo "  Executing the command..."
    $CMD
else 
    echo "  Not executing the command."
fi
cd $CWD
