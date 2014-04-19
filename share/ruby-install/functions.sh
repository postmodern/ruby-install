if (( $UID == 0 )); then
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
	local packages="$(fetch "$ruby/dependencies" "$package_manager" || return $?)"

	if [[ -n "$packages" ]]; then
		log "Installing dependencies for $ruby $ruby_version ..."
		install_packages $packages || return $?
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
# Verifies the Ruby archive matches a checksum.
#
function verify_ruby()
{
	if [[ -n "$ruby_md5" ]]; then
		log "Verifying $ruby_archive ..."
		verify "$src_dir/$ruby_archive" "$ruby_md5" || return $?
	else
		warn "No checksum for $ruby_archive. Proceeding anyways"
	fi
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
	local dest patch

	for (( i=0; i<${#patches[@]}; i++ )) do
		patch="${patches[$i]}"

		if [[ "$patch" == http:\/\/* || "$patch" == https:\/\/* ]]; then
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
	local name

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
