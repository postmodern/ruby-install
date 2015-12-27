#!/usr/bin/env bash

source "$ruby_install_dir/checksums.sh"

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$src_dir" || return $?
	mkdir -p "${install_dir%/*}" || return $?
}

#
# Install Ruby Dependencies
#
function install_deps()
{
	local packages=($(fetch "$ruby/dependencies" "$package_manager" || return $?))

	if (( ${#packages[@]} > 0 )); then
		log "Installing dependencies for $ruby $ruby_version ..."
		install_packages "${packages[@]}" || return $?
	fi

	install_optional_deps || return $?
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
	log "Downloading $ruby_url into $src_dir ..."
	download "$ruby_url" "$src_dir/$ruby_archive" || return $?
}

#
# Verifies the Ruby archive against all known checksums.
#
function verify_ruby()
{
	log "Verifying $ruby_archive ..."

	local file="$src_dir/$ruby_archive"

	verify_checksum "$file" md5 "$ruby_md5"       || return $?
	verify_checksum "$file" sha1 "$ruby_sha1"     || return $?
	verify_checksum "$file" sha256 "$ruby_sha256" || return $?
	verify_checksum "$file" sha512 "$ruby_sha512" || return $?
}

#
# Extract the Ruby archive
#
function extract_ruby()
{
	log "Extracting $ruby_archive to $src_dir/$ruby_dir_name ..."
	extract "$src_dir/$ruby_archive" "$src_dir" || return $?
}

#
# Download any additional patches
#
function download_patches()
{
	local i patch dest

	for (( i=0; i<${#patches[@]}; i++ )) do
		patch="${patches[$i]}"

		if [[ "$patch" == "http://"* || "$patch" == "https://"* ]]; then
			dest="$src_dir/$ruby_dir_name/${patch##*/}"

			log "Downloading patch $patch ..."
			download "$patch" "$dest" || return $?
			patches[$i]="$dest"
		fi
	done
}

#
# Apply any additional patches
#
function apply_patches()
{
	local patch name

	for patch in "${patches[@]}"; do
		name="${patch##*/}"

		log "Applying patch $name ..."
		patch -p1 -d "$src_dir/$ruby_dir_name" < "$patch" || return $?
	done
}

#
# Place holder function for configuring Ruby.
#
function configure_ruby() { return; }

#
# Place holder function for cleaning Ruby.
#
function clean_ruby() { return; }

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
# Remove downloaded archive and unpacked source.
#
function cleanup_source() {
	log "Removing $src_dir/$ruby_archive ..."
	rm "$src_dir/$ruby_archive" || return $?

	log "Removing $src_dir/$ruby_dir_name ..."
	rm -rf "$src_dir/$ruby_dir_name" || return $?
}
