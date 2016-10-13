#### bash functions to be sourced by using bash scripts ####
function get_approval {
    echo -n "Continue? Enter 'y' or 'Y' and press [RETURN]: ";
    read RESPONSE
    if  [[ "$RESPONSE" =~ ^[yY] ]]; then
	# we have a good match
	echo "Continuing..."
    else
	echo "Okay, you entered '$RESPONSE'...quitting."
	exit 1
    fi
}

function check_bash_version {
    VER=`bash --version` > /dev/null
    #echo "DEBUG: bash --version: $VER"
    if  [[ "$VER" =~ "version 3\.[2-9]?" || "$VER" =~ "version 4" ]]; then
	# we have a good match
	#echo "$VER"
	#echo "Version is 3.2 or greater...continuing..."
	echo -n
    else
	echo "$VER"
	echo "Version is < 3.2, cannot continue."
	echo "Upgrade to 3.2 or greater...exiting."
	exit 1
    fi
}

function debug_exit {
    if [[ -z "$1" ]] ; then
	echo "DEBUG exit..."
    else
	echo "DEBUG $1 exit..."
    fi
    exit 2
}

function get_archdir {
    ARCH=$1
    # trim '.tar.gz' or '.zip' or ???
    for s in '.zip' '.tar.gz'
    do
	# echo "suffix is '$s'"
	# last if we get a match
	if [[ "$ARCH" =~ $s$ ]] ; then
	    echo "DEBUG: found a suffix match: '$s'"
	    # trim the suffix and return the result
	    L=`expr length $ARCH`
	    I=`expr index $ARCH $s`
	    echo "DEBUG: length of string '$ARCH' is $L"
	    echo "DEBUG: index of substring '$s' in '$ARCH' is $I"
	    R=${ARCH##s}
	    echo "DEBUG: remainder of string '$ARCH' is $R"
	    debug_exit 1
	fi
    done
    debug_exit 2
    #echo -n $1
}
