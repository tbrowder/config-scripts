#### bash functions to be sourced by using scripts ####
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
