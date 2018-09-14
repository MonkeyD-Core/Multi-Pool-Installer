#!/bin/bash
#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
# This script is intended to be run like this:
#
#   curl https://raw.githubusercontent.com/cryptopool-builders/Multi-Pool-Installer/master/bootstrap.sh | sudo bash
#
#########################################################

if [ -z "$TAG" ]; then
	TAG=v1.0
fi

# Are we running as root?
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root. Did you leave out sudo?"
	exit
fi

# Clone the MultiPool repository if it doesn't exist.
if [ ! -d $HOME/multipool ]; then
	if [ ! -f /usr/bin/git ]; then
		echo Installing git . . .
		apt-get -q -q update
		DEBIAN_FRONTEND=noninteractive apt-get -q -q install -y git < /dev/null
		echo
	fi

	echo Downloading MultiPool Installer $TAG. . .
	git clone \
		-b $TAG --depth 1 \
####		https://github.com/cryptopool-builders/ \ ####
		$HOME/multipool/install \
		< /dev/null 2> /dev/null

	echo
fi

# Change directory to it.
cd $HOME/multipool/install

# Update it.
if [ "$TAG" != `git describe` ]; then
	echo Updating MultiPool Installer to $TAG . . .
	git fetch --depth 1 --force --prune origin tag $TAG
	if ! git checkout -q $TAG; then
		echo "Update failed. Did you modify something in `pwd`?"
		exit
	fi
	echo
fi

# Start setup script.
$HOME/multipool/install/start.sh