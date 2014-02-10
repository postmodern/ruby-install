if (( $UID == 0 )); then
	SRC_DIR="${SRC_DIR:-/usr/local/src}"
	RUBIES_DIR="${RUBIES_DIR:-/opt/rubies}"
else
	SRC_DIR="${SRC_DIR:-$HOME/src}"
	RUBIES_DIR="${RUBIES_DIR:-$HOME/.rubies}"
fi

INSTALL_DIR="${INSTALL_DIR:-$RUBIES_DIR/$RUBY-$RUBY_VERSION}"

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$SRC_DIR" || return $?
	mkdir -p "${INSTALL_DIR%/*}" || return $?
}

#
# Install Ruby Dependencies
#
function install_deps()
{
	local packages="$(fetch "$RUBY/dependencies" "$PACKAGE_MANAGER" || return $?)"

	if [[ -n "$packages" ]]; then
		log "Installing dependencies for $RUBY $RUBY_VERSION ..."
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
	log "Downloading $RUBY_URL into $SRC_DIR ..."
	download "$RUBY_URL" "$SRC_DIR/$RUBY_ARCHIVE" || return $?
}

#
# Verifies the Ruby archive matches a checksum.
#
function verify_ruby()
{
	if [[ -n "$RUBY_MD5" ]]; then
		log "Verifying $RUBY_ARCHIVE ..."
		verify "$SRC_DIR/$RUBY_ARCHIVE" "$RUBY_MD5" || return $?
	else
		warn "No checksum for $RUBY_ARCHIVE. Proceeding anyways"
	fi
}

#
# Extract the Ruby archive
#
function extract_ruby()
{
	log "Extracting $RUBY_ARCHIVE ..."
	extract "$SRC_DIR/$RUBY_ARCHIVE" "$SRC_DIR" || return $?
}

#
# Download any additional patches
#
function download_patches()
{
	local dest

	for patch in "${PATCHES[@]}"; do
		if [[ "$patch" == http:\/\/* || "$patch" == https:\/\/* ]]; then
			log "Downloading patch $patch ..."
			dest="$SRC_DIR/$RUBY_SRC_DIR/${patch##*/}"
			download "$patch" "$dest" || return $?
		fi
	done
}

#
# Apply any additional patches
#
function apply_patches()
{
	local name

	for patch in "${PATCHES[@]}"; do
		name="${patch##*/}"
		log "Applying patch $name ..."

		if [[ "$patch" == http:\/\/* || "$patch" == https:\/\/* ]]; then
			patch="$SRC_DIR/$RUBY_SRC_DIR/$name"
		fi

		patch -p1 -d "$SRC_DIR/$RUBY_SRC_DIR" < "$patch" || return $?
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
