#!/usr/bin/env bash

#
# Functions
#
function log() {
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m"
	else
		echo ">>> $1"
	fi
}

function error() {
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		echo "!!! $1" >&2
	fi
}

function warning() {
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		echo "*** $1" >&2
	fi
}

#
# Pre-install tasks
#
function pre_install() {
	install -d "$SRC_DIR"

	log "Synching Package Manager"
	case "$PACKAGE_MANAGER" in
		apt)	apt-get update ;;
		yum)	yum updateinfo ;;
		brew)	brew update ;;
	esac
}

#
# Install Ruby Dependencies
#
function install_dependencies() {
	local dependencies=$DEPENDENCIES[$PACKAGE_MANAGER]

	if [[ -n "$dependencies" ]]; then
		log "Installing dependencies for $RUBY $RUBY_VERSION ..."

		case "$PACKAGE_MANAGER" in
			apt)
				sudo apt-get install -y $dependencies
				;;
			yum)
				sudo yum install -y $dependencies
				;;
			brew)
				brew install $dependencies || true
				;;
		esac
	fi
}

#
# Download the Ruby archive
#
function download_ruby() {
	log "Downloading $RUBY_URL into $SRC_DIR ..."
	wget -O "$SRC_DIR/$RUBY_ARCHIVE" "$RUBY_URL"
}

#
# Extract the Ruby archive
#
function extract_ruby() {
	log "Installing $RUBY $RUBY_VERSION ..."
	case "$RUBY_ARCHIVE" in
		*.tar.gz)
			tar -xzvf "$SRC_DIR/$RUBY_ARCHIVE" -C "$SRC_DIR"
			;;
		*.tar.bz2)
			tar -xjvf "$SRC_DIR/$RUBY_ARCHIVE" -C "$SRC_DIR"
			;;
		*.zip)
			unzip "$SRC_DIR/$RUBY_ARCHIVE" -d "$SRC_DIR"
			;;
	esac
}

#
# Apply any additional patches
#
function apply_patches() {
	for path in ${PATCHES[*]}; do
		log "Applying patch $path ..."
		patch -p1 < $path
	done
}

#
# Place holder function for configuring Ruby.
#
function configure_ruby() {
}

#
# Place holder function for compiling Ruby.
#
function compile_ruby() {
}

#
# Place holder function for installing Ruby.
#
function install_ruby() {
}

#
# Place holder function for post-install tasks.
#
function post_install() {
}
