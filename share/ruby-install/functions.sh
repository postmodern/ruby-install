source "$ruby_install_dir/checksums.sh"

if (( UID == 0 )); then
	src_dir="${src_dir:-/usr/local/src}"
	rubies_dir="${rubies_dir:-/opt/rubies}"
else
	src_dir="${src_dir:-$HOME/src}"
	rubies_dir="${rubies_dir:-$HOME/.rubies}"
fi

install_dir="${install_dir:-$rubies_dir/$ruby-$ruby_version}"

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
# Looks up a checksum for $ruby_archive.
#
function ruby_checksum()
{
	local algorithm="$1"
	local checksums="$ruby_dir/checksums.$algorithm"

	lookup_checksum "$checksums" "$ruby_archive"
}

#
# Verifies the Ruby archive against all known checksums.
#
function verify_ruby()
{
	local file="$src_dir/$ruby_archive"

	log "Verifying $ruby_archive ..."

	ruby_md5="${ruby_md5:-$(ruby_checksum md5)}"
	ruby_sha1="${ruby_sha1:-$(ruby_checksum sha1)}"
	ruby_sha256="${ruby_sha256:-$(ruby_checksum sha256)}"
	ruby_sha512="${ruby_sha512:-$(ruby_checksum sha512)}"

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
	log "Extracting $ruby_archive to $src_dir/$ruby_src_dir ..."
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
			dest="$src_dir/$ruby_src_dir/${patch##*/}"

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
		patch -p1 -d "$src_dir/$ruby_src_dir" < "$patch" || return $?
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

	log "Removing $src_dir/$ruby_src_dir ..."
	rm -rf "$src_dir/$ruby_src_dir" || return $?
}
