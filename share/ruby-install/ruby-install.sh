#!/usr/bin/env bash

shopt -s extglob

ruby_install_version="0.4.3"
ruby_install_dir="${BASH_SOURCE[0]%/*}"

rubies=(ruby jruby rbx maglev mruby)
patches=()
configure_opts=()
make_opts=()

#
# Auto-detect the package manager.
#
if   command -v apt-get >/dev/null; then package_manager="apt"
elif command -v yum     >/dev/null; then package_manager="yum"
elif command -v port    >/dev/null; then package_manager="port"
elif command -v brew    >/dev/null; then package_manager="brew"
elif command -v pacman  >/dev/null; then package_manager="pacman"
fi

#
# Auto-detect the downloader.
#
if   command -v wget >/dev/null; then downloader="wget"
elif command -v curl >/dev/null; then downloader="curl"
fi

#
# Auto-detect the md5 utility.
#
if   command -v md5sum  >/dev/null; then md5sum="md5sum"
elif command -v md5     >/dev/null; then md5sum="md5"
elif command -v openssl >/dev/null; then md5sum="openssl md5"
fi

#
# Only use sudo if already root.
#
if (( $UID == 0 )); then sudo=""
else                     sudo="sudo"
fi

#
# Prints a log message.
#
function log()
{
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m$1\x1b[0m"
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
		echo -e "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m$1\x1b[0m" >&2
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
		echo -e "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m$1\x1b[0m" >&2
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
	local file="$ruby_install_dir/$1.txt"
	local key="$2"
	local pair="$(grep -E "^$key:" "$file")"

	echo "${pair##$key:*([[:space:]])}"
}

function install_packages()
{
	case "$package_manager" in
		apt)	$sudo apt-get install -y $* || return $? ;;
		yum)	$sudo yum install -y $* || return $?     ;;
		port)   $sudo port install $* || return $?       ;;
		brew)
			local brew_owner="$(/usr/bin/stat -f %Su "$(command -v brew)")"
			sudo -u "$brew_owner" brew install $* ||
			sudo -u "$brew_owner" brew upgrade $* || return $?
			;;
		pacman)
			local missing_pkgs="$(pacman -T $*)"

			if [[ -n "$missing_pkgs" ]]; then
				$sudo pacman -S $missing_pkgs || return $?
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
	local url="$1"
	local dest="$2"

	[[ -d "$dest" ]] && dest="$dest/${url##*/}"
	[[ -f "$dest" ]] && return

	case "$downloader" in
		wget) wget -c -O "$dest.part" "$url" || return $?         ;;
		curl) curl -f -L -C - -o "$dest.part" "$url" || return $? ;;
		"")
			error "Could not find wget or curl"
			return 1
			;;
	esac

	mv "$dest.part" "$dest" || return $?
}

#
# Verifies a file against a md5 checksum.
#
function verify()
{
	local path="$1"
	local md5="$2"

	if [[ -z "$md5sum" ]]; then
		error "Unable to find the md5 checksum utility"
		return 1
	fi

	if [[ -z "$md5" ]]; then
		error "No md5 checksum given"
		return 1
	fi

	if [[ "$($md5sum "$path")" != *$md5* ]]; then
		error "$path is invalid!"
		return 1
	fi
}

#
# Extracts an archive.
#
function extract()
{
	local archive="$1"
	local dest="${2:-${archive%/*}}"

	case "$archive" in
		*.tgz|*.tar.gz) tar -xzf "$archive" -C "$dest" || return $? ;;
		*.tbz|*.tbz2|*.tar.bz2)	tar -xjf "$archive" -C "$dest" || return $? ;;
		*.zip) unzip "$archive" -d "$dest" || return $? ;;
		*)
			error "Unknown archive format: $archive"
			return 1
			;;
	esac
}

#
# Loads function.sh for the given Ruby.
#
function load_ruby()
{
	ruby_dir="$ruby_install_dir/$ruby"

	if [[ ! -d "$ruby_dir" ]]; then
		echo "ruby-install: unsupported ruby: $ruby" >&2
		return 1
	fi

	local expanded_version="$(fetch "$ruby/versions" "$ruby_version")"
	ruby_version="${expanded_version:-$ruby_version}"

	source "$ruby_install_dir/functions.sh" || return $?
	source "$ruby_dir/functions.sh" || return $?

	ruby_md5="${ruby_md5:-$(fetch "$ruby/md5" "$ruby_archive")}"
}

#
# Prints Rubies supported by ruby-install.
#
function known_rubies()
{
	echo "Known ruby versions:"

	for ruby in ${rubies[@]}; do
		echo "  $ruby:"
		cat "$ruby_install_dir/$ruby/versions.txt" | sed -e 's/^/    /' || return $?
	done
}

#
# Prints usage information for ruby-install.
#
function usage()
{
	cat <<USAGE
usage: ruby-install [OPTIONS] [RUBY [VERSION] [-- CONFIGURE_OPTS ...]]

Options:

	-s, --src-dir DIR	Directory to download source-code into
	-r, --rubies-dir DIR	Directory that contains other installed Rubies
	-i, --install-dir DIR	Directory to install Ruby into
	-j, --jobs JOBS		Number of jobs to run in parallel when compiling
	-p, --patch FILE	Patch to apply to the Ruby source-code
	-M, --mirror URL	Alternate mirror to download the Ruby archive from
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
	$ ruby-install -M https://ftp.ruby-lang.org/pub/ruby ruby
	$ ruby-install -M http://www.mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby ruby
	$ ruby-install -p https://raw.github.com/gist/4136373/falcon-gc.diff ruby 1.9.3

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
			-r|--rubies-dir)
				rubies_dir="$2"
				shift 2
				;;
			-i|--install-dir)
				install_dir="$2"
				shift 2
				;;
			-s|--src-dir)
				src_dir="$2"
				shift 2
				;;
			-j|--jobs|-j+([0-9])|--jobs=+([0-9]))
				make_opts+=("$1")
				shift
				;;
			-p|--patch)
				patches+=("$2")
				shift 2
				;;
			-M|--mirror)
				ruby_mirror="$2"
				shift 2
				;;
			-u|--url)
				ruby_url="$2"
				shift 2
				;;
			-m|--md5)
				ruby_md5="$2"
				shift 2
				;;
			--no-download)
				no_download=1
				shift
				;;
			--no-verify)
				no_verify=1
				shift
				;;
			--no-install-deps)
				no_install_deps=1
				shift
				;;
			--no-reinstall)
				no_reinstall=1
				shift
				;;
			-V|--version)
				echo "ruby-install: $ruby_install_version"
				exit
				;;
			-h|--help)
				usage
				exit
				;;
			--)
				shift
				configure_opts=("$@")
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
			ruby="${argv[0]}"
			ruby_version="${argv[1]}"
			;;
		1)
			ruby="${argv[0]}"
			ruby_version="stable"
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
