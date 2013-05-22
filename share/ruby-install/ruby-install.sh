#!/usr/bin/env bash

shopt -s extglob

RUBY_INSTALL_VERSION="0.1.0"

#
# Set SRC_DIR and INSTALL_DIR based on the priviledges of the user.
#
if [[ $UID -eq 0 ]]; then
	[[ -n "$SRC_DIR"     ]] || SRC_DIR="/usr/local/src"
	[[ -n "$INSTALL_DIR" ]] || INSTALL_DIR="/usr/local"
else
	[[ -n "$SRC_DIR"     ]] || SRC_DIR="$HOME/src"
	[[ -n "$INSTALL_DIR" ]] || INSTALL_DIR="$HOME/.local"
fi

RUBIES=(ruby jruby rubinius)
PATCHES=()
CONFIGURE_OPTS=()

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
	error "$*"
	exit -1
}

#
# Searches a file for a key and echos the value.
# If the key cannot be found, the third argument will be echoed.
#
function fetch()
{
	local pair=$(grep -E "^$2: " "$RUBY_DIR/$1.txt")
	local value=${pair#$2: }

	value=${value%%*( )}
	value=${value##*( )}

	if [[ -n "$value" ]]; then echo "$value"
	else                       echo "$3"
	fi
}

#
# Auto-detect system details.
#
function auto_detect()
{
	# Detect the md5 checksum utility
	if   [[ $(type -t md5sum) ]]; then MD5SUM="md5sum"
	elif [[ $(type -t md5)    ]]; then MD5SUM="md5"
	else
		error "Unable to find the md5 checksum utility"
		return 1
	fi

	# Detect wget or curl
	if [[ $(type -t wget) ]]; then
		function download()
		{
			wget -c -O "$2" "$1"
		}
	elif [[ $(type -t curl) ]]; then
		function download()
		{
			curl -C -o "$2" "$1"
		}
	else
		error "Could not find wget or curl"
		return 1
	fi

	# Detect the Package Manager
	if   [[ $(type -t apt-get) == "file" ]]; then PACKAGE_MANAGER="apt"
	elif [[ $(type -t yum)     == "file" ]]; then PACKAGE_MANAGER="yum"
	elif [[ $(type -t brew)    == "file" ]]; then PACKAGE_MANAGER="brew"
	elif [[ $(type -t pacman)  == "file" ]]; then PACKAGE_MANAGER="pacman"
	else
		warn "Could not determine Package Manager. Proceeding anyways."
	fi
}

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$SRC_DIR"

	log "Updating Package Manager"
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
	download "$RUBY_URL" "$SRC_DIR/$RUBY_ARCHIVE"
}

#
# Verifies the Ruby archive matches a checksum.
#
function verify_ruby()
{
	local md5=$(fetch md5 "$RUBY_ARCHIVE")

	if [[ -n "$md5" ]]; then
		log "Verifying $RUBY_ARCHIVE ..."
		if [[ $($MD5SUM "$SRC_DIR/$RUBY_ARCHIVE") == *$md5* ]]; then
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

#
# Loads function.sh for the given Ruby.
#
function load_ruby()
{
	RUBY_DIR="$SHARE_DIR/$RUBY"

	if [[ ! -d "$RUBY_DIR" ]]; then
		echo "ruby-install: unsupported ruby: $RUBY" >&2
		return 1
	fi

	RUBY_VERSION=$(fetch versions "$RUBY_VERSION" "$RUBY_VERSION")

	source "$RUBY_DIR/functions.sh"
}

#
# Prints Rubies supported by ruby-install.
#
function supported_rubies()
{
	echo "Supported Rubies:"

	for ruby in ${RUBIES[@]}; do
		echo "  $ruby:"
		cat "$SHARE_DIR/$ruby/versions.txt" | sed -e 's/^/    /'
	done
}

#
# Prints usage information for ruby-install.
#
function usage()
{
	cat <<USAGE >&2
usage: ruby-install [OPTIONS] [RUBY [VERSION]] [-- CONFIGURE_OPTS ...]

Options:

	-s, --src-dir DIR	Directory to download source-code into
	-i, --install-dir DIR	Directory to install Ruby into
	-p, --patch FILE	Patch to apply to the Ruby source-code
	    --skip-update	Skip updating the Package Manager
	-V, --version		Prints the version
	-h, --help		Prints this message

Examples:

	$ ruby-install ruby
	$ ruby-install ruby 2.0
	$ ruby-install ruby 2.0.0-p0
	$ ruby-install ruby -- --with-openssl-dir=...

USAGE
}

#
# Parses command-line options for ruby-install.
#
function parse_options()
{
	local argv=()

	while [[ $# -gt 0 ]]; do
		case $1 in
			-i|--install-dir)
				INSTALL_DIR="$2"
				shift 2
				;;
			-s|--src-dir)
				SRC_DIR="$2"
				shift 2
				;;
			-p|--patch)
				PATCHES+=($2)
				shift 2
				;;
			-V|--version)
				echo "ruby-install: $RUBY_INSTALL_VERSION"
				exit
				;;
			-h|--help)
				usage
				exit
				;;
			--)
				shift
				CONFIGURE_OPTS=$*
				break
				;;
			-*)
				echo "ruby-install: unrecognized option $1" >&2
				return 1
				;;
			*)
				argv+=($1)
				shift
				;;
		esac
	done

	case ${#argv[*]} in
		2)
			RUBY="${argv[0]}"
			RUBY_VERSION="${argv[1]}"
			;;
		1)
			RUBY="${argv[0]}"
			RUBY_VERSION="stable"
			;;
		0)
			echo "ruby-install: too few arguments" >&2
			usage
			return 1
			;;
		*)
			echo "ruby-install: too many arguments: ${argv[*]}" >&2
			usage
			return 1
			;;
	esac
}
