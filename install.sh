#! /bin/bash

# Author: cyberpunkprogrammer (github.com/cyberpunkprogrammer)
# Date: March 12, 2020

USERHOME=$HOME
GOHOME=$USERHOME/go
PIXELHOME=$USERHOME/pixel


function installGo {
	echo "Installing go."
}

function installPixel {
	echo "Installing pixel."
}

# Check for previous pixel installations.
if [ -d $PIXELHOME ]
then
	read -r -p "Pixel installation found, would you like to remove it? [y/N] " response
        case "$response" in
                [yY][eE][sS]|[yY])
                        #sudo rm -rf #PIXELHOME
                        echo "Pixel installation has been removed."
                ;;
        esac
fi

# Check for previous go installations.
if [ -d /usr/local/go ]
then
	read -r -p "Go installation found, would you like to remove it? [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			#sudo rm -rf /usr/local/go
			echo "Go installation has been removed."
				
			read -r -p "Would you like to install go? [y/N] " response
		 	case "$response" in
				[yY][eE][sS]|[yY])
			 		installGo
			 	
				;;
		 	esac
		;;
	esac
fi
