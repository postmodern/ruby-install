#!/usr/bin/env bash

if [[ $UID -eq 0 ]]; then
	[[ -n "$SRC_DIR"     ]] || SRC_DIR="/usr/local/src"
	[[ -n "$INSTALL_DIR" ]] || INSTALL_DIR="/usr/local"
else
	[[ -n "$SRC_DIR"     ]] || SRC_DIR="$HOME/src"
	[[ -n "$INSTALL_DIR" ]] || INSTALL_DIR="$HOME/.local"
fi

#
# Detect the Package Manager
#
if   [[ $(type -t apt-get) == "file" ]]; then PACKAGE_MANAGER="apt"
elif [[ $(type -t yum)     == "file" ]]; then PACKAGE_MANAGER="yum"
elif [[ $(type -t brew)    == "file" ]]; then PACKAGE_MANAGER="brew"
elif [[ $(type -t pacman)  == "file" ]]; then PACKAGE_MANAGER="pacman"
else
	warn "Could not determine Package Manager. Proceeding anyways."
fi
