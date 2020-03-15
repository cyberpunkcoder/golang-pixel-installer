#! /bin/bash

# Author: cyberpunkprogrammer (github.com/cyberpunkprogrammer) (cyberpunkprogrammer@gmail.com)
# Date: March 13, 2020

# Exit if a command if the script fails.
set -e

GOVERSION=1.14
GOLIBRARY=/usr/lib/go
GOPROGRAM=/usr/local/go
GOHOME=$HOME/go
PIXELHOME=$HOME/pixel
USERPROFILE=$HOME/.profile
DOWNLOADURL=https://storage.googleapis.com/golang

function installGo {
	echo "Installing go."

	# Check system architecture.
	ARCH=$(uname -m)
	case $ARCH in
		"x86_64") ARCH=amd64 ;;
    		"armv6") ARCH=armv6l ;;
		"armv8") ARCH=arm64 ;;
		.*386.*) ARCH=386 ;;
	esac

	# Check for latest version of go.
	printf "Checking for latest version of go... "
	while true
	do
		CHECKVERSION=$(bc <<< "$GOVERSION+0.01")

		if [[ `wget -S --spider $DOWNLOADURL/go$CHECKVERSION.linux-$ARCH.tar.gz  2>&1 | grep 'HTTP/1.1 200 OK'` ]]
		then
			GOVERSION=$(bc <<< "$GOVERSION+0.01")
		else
			echo "Found version $GOVERSION"
			break	
		fi
	done
	
	# Download go.
	echo "Downloading go"
	wget -S $DOWNLOADURL/go$GOVERSION.linux-$ARCH.tar.gz
	
	# Install go.
	echo "Unpacking files"
	tar -C /usr/local -xzf go$GOVERSION.linux-$ARCH.tar.gz

	# Remove tar file.
	rm -rf go$GOVERSION.linux-$ARCH.tar.gz*
	
	#Add profile additions.
	grep -qxF 'export PATH=$PATH:/usr/local/go/bin' $USERPROFILE || echo 'export PATH=$PATH:/usr/local/go/bin' >> $USERPROFILE
	grep -qxF 'export GOPATH=$HOME/go' $USERPROFILE || echo 'export GOPATH=$HOME/go' >> $USERPROFILE
	source $USERPROFILE

	echo "Go installation complete."
}

function uninstallGo {
	rm -rf /usr/lib/go-*
	rm -rf $GOPROGRAM
	rm -rf $GOLIBRARY
	rm -rf $GOHOME
	sed -i '/export PATH=$PATH:\/usr\/local\/go\/bin/d' $USERPROFILE
	sed -i '/export GOPATH=$HOME\/go/d' $USERPROFILE
	
	echo "Go uninstalled"
}

function installPixel {
	echo "Installing pixel"
}

function uninstallPixel {
	rm -rf $PIXELHOME
	echo "Pixel uninstalled"
}

function pixelPrompt {
	read -r -p "Would you like to install Pixel? [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			installPixel
		;;
	esac	
}

# Check to make sure script has admin privilidges.
if [[ $EUID -ne 0 ]]; then
	echo "You must run this script with root access, ( try sudo ./install )"
   exit 1
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
fi

# Check for previous pixel installations.
if [ -d $PIXELHOME ]
then
	read -r -p "Pixel installation found, would you like to remove it? [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			uninstallPixel
			
			read -r -p "Would you like to reinstall Pixel? [y/N] " response
			case "$response" in
				[yY][eE][sS]|[yY])
					installPixel
				;;
			esac
		;;
	esac
else
	read -r -p "Would you like to install Pixel? [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			installPixel
		;;
	esac
fi
