#!/usr/bin/env bash

#
# Convert a path to an absolute path.
#
function absolute_path()
{
	local path="$1"

	if [[ "$path" == "/"* ]]; then
		echo -n "$path"
	else
		echo -n "${PWD}/${path}"
	fi
}

#
# Checks if a path is "writable".
#
function check_write_permissions()
{
	local path="$1"

	while [[ -n "$path" ]]; do
		if [[ -e "$path" ]] && [[ -w "$path" ]]; then
			return
		fi

		path="${path%/*}"
	done

	return 1
}

#
# Downloads a URL.
#
function download()
{
	local url="$1"
	local dest="$2"

	if [[ -z "$downloader" ]]; then
		error "Could not find wget or curl"
		return 1
	fi

	local quiet

	if [[ ! -t 1 ]]; then
		quiet=1
	fi

	[[ -d "$dest" ]] && dest="$dest/${url##*/}"
	[[ -f "$dest" ]] && return

	mkdir -p "${dest%/*}" || return $?

	case "$downloader" in
		wget)
			run wget ${quiet:+-q} -c -O "$dest.part" "$url" || return $?
			;;
		curl)
			run curl ${quiet:+-s -S} -f -L -C - -o "$dest.part" "$url" || return $?
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

	mkdir -p "$dest" || return $?

	case "$archive" in
		*.tgz|*.tar.gz)
			run tar -xzf "$archive" -C "$dest" || return $?
			;;
		*.tbz|*.tbz2|*.tar.bz2)
			run tar -xjf "$archive" -C "$dest" || return $?
			;;
		*.txz|*.tar.xz)
			debug "xzcat $archive | tar -xf - -C $dest"
			xzcat "$archive" | tar -xf - -C "$dest" || return $?
			;;
		*.zip)
			run unzip "$archive" -d "$dest" || return $?
			;;
		*)
			error "Unknown archive format: $archive"
			return 1
			;;
	esac
}

#
# Copies files from within a source directory into a destination directory.
#
function copy_into()
{
	local src="$1"
	local dest="$2"

	mkdir -p "$dest" || return $?
	run cp -R "$src"/* "$dest" || return $?
}
