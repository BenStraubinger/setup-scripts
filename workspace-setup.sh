#!/bin/bash


# Check this is a Fedora 23 system
grep 'Fedora' /etc/redhat-release | grep 'Twenty Three'
if [[ "$?" -ne 0 ]]; then
    echo 'ERROR: Expected Fedora 23.' >&2
    exit 1
fi




# Check the script is being run as a user
WS_USER="$(whoami)"
if [[ "$WS_USER" == "root" ]]; then
    echo 'ERROR: This script should be run as a regular user, not root. ' >&2
    exit 1
else
	echo "Setting up development workspace for user: $WS_USER"
fi




echo 'Installing base packages:'

sudo dnf -y groupinstall 'Development tools'
sudo dnf -y groupinstall 'C Development Tools and Libraries'
sudo dnf -y install libxcb libxcb-devel xcb-util* libjpeg-turbo* openal-soft openal-soft-devel flac-devel

# TODO: verify before continuing...
echo 'Base packages were installed successfully.'
echo ''




# Check if the workspace is already configured:
if [[ "$WS_ROOT" == "" ]]; then
	echo 'Setting up workspace environment:'

	# Set WS_ROOT and append to the user's .bashrc file:
	WS_ROOT="$HOME/workspace"
	echo "export WS_ROOT=$WS_ROOT" >> $HOME/.bashrc

	# Check if the directory exists, create if not found
	if [[ -d $WS_ROOT ]]; then
		echo "Workspace directory found: $WS_ROOT"
	else
		echo "Creating workspace directory: $WS_ROOT"
		mkdir -p $WS_ROOT
	fi
else
	echo "Workspace environment appears to already be configured: WS_ROOT=$WS_ROOT"
	echo ""
fi




# Check for the workspace local executable directory
if [[ "$WS_BIN" == "$WS_ROOT/bin" ]]; then
	echo "Workspace local executable dir: $WS_BIN"
	echo ""
else
	WS_BIN="$WS_ROOT/bin"
	echo "Updating PATH with the workspace local executable dir: $WS_BIN"
	echo "export WS_BIN=$WS_BIN" >> $HOME/.bashrc
	echo 'export PATH=$WS_BIN:$PATH' >> $HOME/.bashrc
	echo ""
fi

# Check if the directory exists, create if not found
if [[ ! -d $WS_BIN ]]; then
	echo "Creating directory: $WS_BIN"
	mkdir -p $WS_BIN
fi




# TODO: verify before continuing...
echo ""
echo "Development workspace is configured and up to date."
echo ""
