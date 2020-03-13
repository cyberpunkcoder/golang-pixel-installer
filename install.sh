#! /bin/bash

# Author: cyberpunkprogrammer (github.com/cyberpunkprogrammer)
# Date: March 13, 2020

# Exit if a command in the script fails.
set -o errexit

USERHOME=$HOME
GOPROGRAM=/usr/local/go
GOHOME=$USERHOME/go
PIXELHOME=$USERHOME/pixel
 
function installGo {
	echo "Installing go."

	apt update

	go version
	go env

	echo "Go installation complete."
}

function uninstallGo {
	rm -rf $GOHOME
	rm -rf $GOPROGRAM
	sed -i '/export PATH=$PATH:\/usr\/local\/go\/bin/d' .profile
	sed -i '/export GOPATH=$HOME\/go/d' .profile
	
	echo "Go uninstalled."
}

function installPixel {
	echo "Installing pixel."
}

function uninstallPixel {
	rm -rf $PIXELHOME
	echo "Pixel uninstalled."
}

# Check for previous pixel installations.
if [ -d $PIXELHOME ]
then
	read -r -p "Pixel installation found, would you like to remove it? [y/N] " response
        case "$response" in
                [yY][eE][sS]|[yY])
                	uninstallPixel
		;;
        esac
fi

# Check for previous go installations.
if [ -d $GOPROGRAM ] || [ -d $GOHOME ]
then
	read -r -p "Go installation found, would you like to remove it? [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			uninstallGo
			
			read -r -p "Would you like to reinstall go? [y/N] " response
		 	case "$response" in
				[yY][eE][sS]|[yY])
			 		installGo
				;;
		 	esac
		;;
	esac
else
	installGo

	read -r -p "Would you like to install Pixel? [y/N] " response
     		case "$response" in
 			[yY][eE][sS]|[yY])
			installPixel
		;;
	esac
fi


