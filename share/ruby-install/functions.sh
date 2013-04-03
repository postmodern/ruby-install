#!/usr/bin/env bash

shopt -s extglob

declare -a PATCHES
declare -a CONFIGURE_OPTS

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
# Prints a warn message.
#
function warn()
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
# Prints an error message and exists with -1.
#
function fail()
{
	error $1
	exit -1
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
function install_deps()
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

	install_optional_deps
}

#
# Install any optional dependencies.
#
function install_optional_deps() { return; }

#
# Download the Ruby archive
#
function download_ruby()
{
	log "Downloading $RUBY_URL into $SRC_DIR ..."
	wget -c -O "$SRC_DIR/$RUBY_ARCHIVE" "$RUBY_URL"
}

#
# Verifies the Ruby archive matches a checksum.
#
function verify_ruby()
{
	local checksum=$(fetch md5 "$RUBY_ARCHIVE")

	if [[ -n "$checksum" ]]; then
		local manifest="$checksum  $SRC_DIR/$RUBY_ARCHIVE"

		log "Verifying $RUBY_ARCHIVE ..."
		if [[ `echo "$manifest" | md5sum -c -` == *OK* ]]; then
			log "Verified $RUBY_ARCHIVE"
		else
			error "$RUBY_ARCHIVE is invalid!"
			return 1
		fi
	else
		warn "No checksum for $RUBY_ARCHIVE. Proceeding anyways"
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
function configure_ruby() { return; }

#
# Place holder function for compiling Ruby.
#
function compile_ruby() { return; }

#
# Place holder function for installing Ruby.
#
function install_ruby() { return; }

#
# Place holder function for post-install tasks.
#
function post_install() { return; }
