#!/usr/bin/env bash

source "$ruby_install_dir/package_manager.sh"

#
# Auto-detect the downloader.
#
if   command -v wget >/dev/null; then downloader="wget"
elif command -v curl >/dev/null; then downloader="curl"
fi

#
# Don't use sudo if already root.
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
# The archive should contain a single directory.
#
function extract()
{
	local archive="$1"
	local dest="$2"
	local tmp="${dest}_tmp"

	rm -rf "$tmp" "$dest" || return $?
	mkdir "$tmp" || return $?

	case "$archive" in
		*.tgz|*.tar.gz) tar -xzf "$archive" -C "$tmp" || return $? ;;
		*.tbz|*.tbz2|*.tar.bz2)	tar -xjf "$archive" -C "$tmp" || return $? ;;
		*.zip) unzip "$archive" -d "$tmp" || return $? ;;
		*)
			error "Unknown archive format: $archive"
			return 1
			;;
	esac

	mv "$tmp"/* "$dest" || return $?
	rmdir "$tmp" || return $?
}
