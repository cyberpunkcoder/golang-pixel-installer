![gopixel](img/gopixel.png)

Bash script to install golang and/or pixel game engine on Ubuntu.
(Tested on Ubuntu 19.10, March 29 2020)

## Install ##

Run the script ```sudo ./gopixel.sh``` to be prompted to install golang and the pixel game engine.
Alternatively, you can run ```sudo ./gopixel.sh -i``` to auto-install without being prompted.

You will be prompted if you wish to remove any previous installations.

## Uninstall ##

Run the script ```sudo ./gopixel.sh``` to be prompted to uninstall golang and the pixel game engine.
You can run ```sudo ./gopixel.sh -u``` to auto-uninstall without being prompted.

## How It Works ##

Previous installations of go and pixel are removed from you system if desired.
Script checks for the latest version of go and installs from the official google api location.
Pixel game engine and all prerequisites are installed from the official creator's github.

## Credit ##

[Official Golang Website](https://golang.org/ "golang.org") | 
[Official Pixel Game Engine Repo](https://github.com/faiface/pixel "github.com/faiface/pixel")

