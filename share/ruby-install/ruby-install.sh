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

function update_package_manager()
{
	if   [[ $(type -t apt-get) ]]; then sudo apt-get update
	elif [[ $(type -t yum)     ]]; then sudo yum updateinfo
	elif [[ $(type -t brew)    ]]; then brew update
	elif [[ $(type -t pacman)  ]]; then sudo pacman -Sy
	else
		warn "Could not determine Package Manager. Proceeding anyways."
	fi
}

function install_packages()
{
	if   [[ $(type -t apt-get) ]]; then sudo apt-get install -y $*
	elif [[ $(type -t yum)     ]]; then sudo yum install -y $*
	elif [[ $(type -t brew)    ]]; then brew install $*
	elif [[ $(type -t pacman)  ]]; then
		local missing_pkgs=$(pacman -T $*)

		[[ -n "$missing_pkgs" ]] && sudo pacman -S $missing_pkgs
	else
		warn "Could not determine Package Manager. Proceeding anyways."
	fi
}

#
# Downloads a URL.
#
function download()
{
	if   [[ $(type -t wget) ]]; then wget -c -O "$2" "$1"
	elif [[ $(type -t curl) ]]; then curl -C -o "$2" "$1"
	else
		error "Could not find wget or curl"
		return 1
	fi
}

#
# Verifies a file against a MD5 checksum.
#
function verify()
{
	local md5sum

	# Detect the md5 checksum utility
	if   [[ $(type -t md5sum) ]]; then md5sum="md5sum"
	elif [[ $(type -t md5)    ]]; then md5sum="md5"
	else
		error "Unable to find the md5 checksum utility"
		return 1
	fi

	if [[ $($md5sum "$1") == *$2* ]]; then
		log "Verified $1"
	else
		error "$1 is invalid!"
		return 1
	fi
}

#
# Extracts an archive.
#
function extract()
{
	case "$1" in
		*.tar.gz)	tar -xzf "$1" -C "$2" ;;
		*.tar.bz2)	tar -xjf "$1" -C "$2" ;;
		*.zip)		unzip "$1" -d "$2" ;;
		*)
			error "Unknown archive format: $1"
			return 1
			;;
	esac
}

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
	RUBY_ARCHIVE="$RUBY-$RUBY_VERSION.tar.gz"
	RUBY_SRC_DIR="$RUBY-$RUBY_VERSION"

	source "$SHARE_DIR/functions.sh"
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
