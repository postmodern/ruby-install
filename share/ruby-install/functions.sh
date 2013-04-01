#!/usr/bin/env bash

shopt -s extglob

#
# Prints a log message.
#
function log()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m"
	else
		echo ">>> $1"
	fi
}

#
# Prints a warning message.
#
function warning()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		echo "*** $1" >&2
	fi
}

#
# Prints an error message.
#
function error()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		echo "!!! $1" >&2
	fi
}

#
# Searches a file for a key and echos the value.
# If the key cannot be found, the third argument will be echoed.
#
function fetch()
{
	local pair=$(grep -E "^$2: " "$RUBY_DIR/$1.txt")
	local value=${pair#$2:}

	value=${value%%*( )}
	value=${value##*( )}

	if [[ -n "$value" ]]; then echo "$value"
	else                       echo "$3"
	fi
}

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$SRC_DIR"

	log "Synching Package Manager"
	case "$PACKAGE_MANAGER" in
		apt)	sudo apt-get update ;;
		yum)	sudo yum updateinfo ;;
		brew)	brew update ;;
		pacman) sudo pacman -Sy ;;
	esac
}

#
# Install Ruby Dependencies
#
function install_dependencies()
{
	local packages=$(fetch dependencies "$PACKAGE_MANAGER")

	if [[ -n "$packages" ]]; then
		log "Installing dependencies for $RUBY $RUBY_VERSION ..."

		case "$PACKAGE_MANAGER" in
			apt)    sudo apt-get install -y $packages ;;
			yum)    sudo yum install -y $packages ;;
			brew)   brew install $packages || true ;;
			pacman)
				packages=$(pacman -T $packages)

				[[ -n "$packages" ]] && sudo pacman -S $packages
				;;
		esac
	fi
}

#
# Download the Ruby archive
#
function download_ruby()
{
	log "Downloading $RUBY_URL into $SRC_DIR ..."
	wget -O "$SRC_DIR/$RUBY_ARCHIVE" "$RUBY_URL"
}

#
# Verifies the Ruby archive matches a checksum.
#
function verify_ruby()
{
	local checksum=$(fetch checksums "$RUBY_ARCHIVE")

	if [[ -n "$checksum" ]]; then
		log "Verifying $RUBY_ARCHIVE ..."
		echo "$checksum  $SRC_DIR/$RUBY_ARCHIVE" | md5sum -c -
	else
		warning "No checksum for $RUBY_ARCHIVE. Proceeding anyways"
	fi
}

#
# Extract the Ruby archive
#
function extract_ruby()
{
	log "Installing $RUBY $RUBY_VERSION ..."
	case "$RUBY_ARCHIVE" in
		*.tar.gz)  tar -xzf "$SRC_DIR/$RUBY_ARCHIVE" -C "$SRC_DIR" ;;
		*.tar.bz2) tar -xjf "$SRC_DIR/$RUBY_ARCHIVE" -C "$SRC_DIR" ;;
		*.zip)     unzip "$SRC_DIR/$RUBY_ARCHIVE" -d "$SRC_DIR" ;;
		*)
			error "Unknown archive format: $RUBY_ARCHIVE"
			return 1
	esac
}

#
# Apply any additional patches
#
function apply_patches()
{
	for path in ${PATCHES[*]}; do
		log "Applying patch $path ..."
		patch -p1 < $path
	done
}

#
# Place holder function for configuring Ruby.
#
function configure_ruby()
{
	return 0
}

#
# Place holder function for compiling Ruby.
#
function compile_ruby()
{
	return 0
}

#
# Place holder function for installing Ruby.
#
function install_ruby()
{
	return 0
}

#
# Place holder function for post-install tasks.
#
function post_install()
{
	return 0
}
