#!/usr/bin/env bash

#
# Auto-detect the package manager.
#
if   command -v apt-get >/dev/null; then package_manager="apt"
elif command -v dnf     >/dev/null; then package_manager="dnf"
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
# Only use sudo if already root.
#
if (( UID == 0 )); then sudo=""
else                    sudo="sudo"
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
	error "$@"
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
	local line

	while IFS="" read -r line; do
		if [[ "$line" == "$key:"* ]]; then
			echo "${line##$key:*([[:space:]])}"
		fi
	done < "$file"
}

function install_packages()
{
	case "$package_manager" in
		apt)	$sudo apt-get install -y "$@" || return $? ;;
		dnf|yum)$sudo $package_manager install -y "$@" || return $?     ;;
		port)   $sudo port install "$@" || return $?       ;;
		brew)
			local brew_owner="$(/usr/bin/stat -f %Su "$(command -v brew)")"
			sudo -u "$brew_owner" brew install "$@" ||
			sudo -u "$brew_owner" brew upgrade "$@" || return $?
			;;
		pacman)
			local missing_pkgs=($(pacman -T "$@"))

			if (( ${#missing_pkgs[@]} > 0 )); then
				$sudo pacman -S "${missing_pkgs[@]}" || return $?
			fi
			;;
		"")	warn "Could not determine Package Manager. Proceeding anyway." ;;
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

	mkdir -p "${dest%/*}" || return $?

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
