#!/bin/bash

if [[ $UID -eq 0 ]]; then
	[[ -z "$SRC_DIR"     ]] && SRC_DIR="/usr/local/src"
	[[ -z "$INSTALL_DIR" ]] && INSTALL_DIR="/usr/local"
else
	[[ -z "$SRC_DIR"     ]] && SRC_DIR="$HOME/src"
	[[ -z "$INSTALL_DIR" ]] && INSTALL_DIR="$HOME/.local"
fi

declare -A DEPENDENCIES
declare -a PATCHES
declare -a CONFIGURE_OPTS

#
# Detect the Package Manager
#
if   [[ $(type -t apt-get) == "file" ]]; then PACKAGE_MANAGER="apt"
elif [[ $(type -t yum)     == "file" ]]; then PACKAGE_MANAGER="yum"
elif [[ $(type -t brew)    == "file" ]]; then PACKAGE_MANAGER="brew"
else
	warning "Could not determine Package Manager. Proceeding anyways."
fi
