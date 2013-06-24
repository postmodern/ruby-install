#!/usr/bin/env bash

shopt -s extglob

RUBY_INSTALL_VERSION="0.2.0"
RUBY_INSTALL_DIR=$(dirname ${BASH_SOURCE[0]})

RUBIES=(ruby jruby rubinius maglev)
PATCHES=()
CONFIGURE_OPTS=()

#
# Auto-detection the package manager.
#
if   [[ $(type -t apt-get) ]]; then PACKAGE_MANAGER="apt"
elif [[ $(type -t yum)     ]]; then PACKAGE_MANAGER="yum"
elif [[ $(type -t brew)    ]]; then PACKAGE_MANAGER="brew"
elif [[ $(type -t pacman)  ]]; then PACKAGE_MANAGER="pacman"
fi

#
# Auto-detect the downloader.
#
if   [[ $(type -t wget) ]]; then DOWNLOADER="wget"
elif [[ $(type -t curl) ]]; then DOWNLOADER="curl"
fi

#
# Auto-detect the md5 utility.
#
if   [[ $(type -t md5sum) ]]; then MD5SUM="md5sum"
elif [[ $(type -t md5)    ]]; then MD5SUM="md5"
fi

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
	local pair="$(grep -E "^$2: " "$RUBY_INSTALL_DIR/$1.txt")"
	local value="${pair##$2:*( )}"

	echo "$value"
}

function install_packages()
{
	case "$PACKAGE_MANAGER" in
		apt)	sudo apt-get install -y $* ;;
		yum)	sudo yum install -y $*     ;;
		brew)	brew install $*            ;;
		pacman)
			local missing_pkgs=$(pacman -T $*)

			if [[ -n "$missing_pkgs" ]]; then
				sudo pacman -S $missing_pkgs
			fi
			;;
		"")	warn "Could not determine Package Manager. Proceeding anyways." ;;
	esac
}

#
# Downloads a URL.
#
function download()
{
	case "$DOWNLOADER" in
		wget) wget -c -O "$2" "$1"      ;;
		curl) curl -L -C - -o "$2" "$1" ;;
		"")
			error "Could not find wget or curl"
			return 1
			;;
	esac
}

#
# Verifies a file against a MD5 checksum.
#
function verify()
{
	if [[ -z "$MD5SUM" ]]; then
		error "Unable to find the md5 checksum utility"
		return 1
	fi

	if [[ "$($MD5SUM "$1")" != *$2* ]]; then
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
	RUBY_DIR="$RUBY_INSTALL_DIR/$RUBY"

	if [[ ! -d "$RUBY_DIR" ]]; then
		echo "ruby-install: unsupported ruby: $RUBY" >&2
		return 1
	fi

	local expanded_version="$(fetch "$RUBY/versions" "$RUBY_VERSION")"
	RUBY_VERSION="${expanded_version:-$RUBY_VERSION}"

	source "$RUBY_INSTALL_DIR/functions.sh"
	source "$RUBY_DIR/functions.sh"

	RUBY_MD5="${RUBY_MD5:-$(fetch "$RUBY/md5" "$RUBY_ARCHIVE")}"
}

#
# Prints Rubies supported by ruby-install.
#
function known_rubies()
{
	echo "Known ruby versions:"

	for ruby in ${RUBIES[@]}; do
		echo "  $ruby:"
		cat "$RUBY_INSTALL_DIR/$ruby/versions.txt" | sed -e 's/^/    /'
	done
}

#
# Prints usage information for ruby-install.
#
function usage()
{
	cat <<USAGE
usage: ruby-install [OPTIONS] [RUBY [VERSION]] [-- CONFIGURE_OPTS ...]

Options:

	-s, --src-dir DIR	Directory to download source-code into
	-i, --install-dir DIR	Directory to install Ruby into
	-p, --patch FILE	Patch to apply to the Ruby source-code
	-u, --url URL		Alternate URL to download the Ruby archive from
	-m, --md5 MD5		MD5 checksum of the Ruby archive
	--no-download		Use the previously downloaded Ruby archive
	--no-verify		Do not verify the downloaded Ruby archive
	--no-install-deps	Do not install build dependencies before installing Ruby
	--no-reinstall  	Skip installation if another Ruby is detected in same location
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
				PATCHES+=("$2")
				shift 2
				;;
			-u|--url)
				RUBY_URL="$2"
				shift 2
				;;
			-m|--md5)
				RUBY_MD5="$2"
				shift 2
				;;
			--no-download)
				NO_DOWNLOAD=1
				shift
				;;
			--no-verify)
				NO_VERIFY=1
				shift
				;;
			--no-install-deps)
				NO_INSTALL_DEPS=1
				shift
				;;
			--no-reinstall)
				NO_REINSTALL=1
				shift
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
			usage 1>&2
			return 1
			;;
		*)
			echo "ruby-install: too many arguments: ${argv[*]}" >&2
			usage 1>&2
			return 1
			;;
	esac
}
