#! /bin/bash

# Author: cyberpunkprogrammer (github.com/cyberpunkprogrammer) (cyberpunkprogrammer@gmail.com)
# Date: March 13, 2020

# Exit if a command if the script fails.
set -e

GOVERSION=1.14
GOLIBRARY=/usr/lib/go
GOPROGRAM=/usr/local/go
USERHOME=/home/$SUDO_USER
GOHOME=$USERHOME/go
PIXELHOME=$GOHOME/src/github.com/faiface
USERPROFILE=$USERHOME/.profile
DOWNLOADURL=https://storage.googleapis.com/golang
INSTALL=false
UNINSTALL=false

# Flags to no propt install or uninstall.
if [ "$1" == "-i" ];
then
	echo "Auto install"
	INSTALL=true
elif [ "$1" == "-u" ];
then
	echo "Auto uninstall"
	UNINSTALL=true
fi

function installGo {
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
	wget $DOWNLOADURL/go$GOVERSION.linux-$ARCH.tar.gz -q --show-progress

	# Install go.
	echo "Installing go"
	sudo -u $SUDO_USER mkdir $GOHOME
	tar -C /usr/local -xzf go$GOVERSION.linux-$ARCH.tar.gz

	# Remove tar file.
	rm -rf go$GOVERSION.linux-$ARCH.tar.gz*

	#Add profile additions.
	grep -qxF 'export PATH=$PATH:/usr/local/go/bin' $USERPROFILE || echo 'export PATH=$PATH:/usr/local/go/bin' >> $USERPROFILE
	grep -qxF 'export GOPATH=$HOME/go' $USERPROFILE || echo 'export GOPATH=$HOME/go' >> $USERPROFILE

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
	echo "Installing pixel prerequisites"

	apt install xorg-dev
	sudo apt install mesa-utils

	echo "Downloading pixel"

	export PATH=$PATH:/usr/local/go/bin
	export GOPATH=$GOHOME

	go get github.com/faiface/pixel
	go get github.com/faiface/glhf
	go get github.com/go-gl/glfw/v3.2/glfw

	echo "Pixel installed"

	if [ $INSTALL == true ]
	then
		installPixelExamples
	else
		read -r -p "Would you like to install pixel game examples? [y/N] " response
			case "$response" in
				[yY][eE][sS]|[yY])
					installPixelExamples
				;;
			esac
	fi

	echo "IMPORTANT: To run any pixel games, restart your machine or type 'source \$HOME/.profile'"
}

function uninstallPixel {
	rm -rf $PIXELHOME
	echo "Pixel uninstalled"

	if [ -d $USERHOME/pixel-examples ]
	then
		uninstallPixelExamples
	fi
}

function installPixelExamples {
	git clone https://github.com/faiface/pixel-examples.git $USERHOME/pixel-examples

	if [ $INSTALL == true ]
	then
		cd $USERHOME/pixel-examples/platformer && go run main.go
	else
		read -r -p "Would you like to run a pixel example? [y/N] " response
			case "$response" in
				[yY][eE][sS]|[yY])
					cd $USERHOME/pixel-examples/platformer && go run main.go
				;;
			esac
	fi
}

function uninstallPixelExamples {
	rm -rf $USERHOME/pixel-examples
	echo "Pixel examples uninstalled"
}

# Check to make sure script has root access.
if [[ $EUID -ne 0 ]]; then
	echo "You must run this script with root access, try 'sudo ./gopixel.sh'"
	exit 1
fi

if [ $UNINSTALL == true ]
then
	uninstallGo
elif [ $INSTALL == true ]
then
	# Check for previous go installations
	if [ -d $GOPROGRAM ] || [ -d $GOHOME ]
	then
		uninstallGo
	fi
	installGo
else
	# Check for previous go installations
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
fi

if [ $UNINSTALL == true ]
then
	uninstallPixel
elif [ $INSTALL == true ]
then
	# Check for previous pixel installations
	if [ -d $PIXELHOME ]
	then
		uninstallPixel
	fi
	installPixel
else
	if [ -d $PIXELHOME ]
	then
		read -r -p "Pixel installation found, would you like to remove it? [y/N] " response
		case "$response" in
			[yY][eE][sS]|[yY])
				uninstallPixel

				read -r -p "Would you like to reinstall pixel? [y/N] " response
				case "$response" in
					[yY][eE][sS]|[yY])
						installPixel
					;;
				esac
			;;
		esac
	else
		read -r -p "Would you like to install pixel? [y/N] " response
			case "$response" in
				[yY][eE][sS]|[yY])
					installPixel
				;;
			esac
	fi
fi
