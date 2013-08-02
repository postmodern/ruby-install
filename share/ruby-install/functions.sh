if [[ $UID -eq 0 ]]; then
	SRC_DIR="${SRC_DIR:-/usr/local/src}"
	INSTALL_DIR="${INSTALL_DIR:-/opt/rubies/$RUBY-$RUBY_VERSION}"
else
	SRC_DIR="${SRC_DIR:-$HOME/src}"
	INSTALL_DIR="${INSTALL_DIR:-$HOME/.rubies/$RUBY-$RUBY_VERSION}"
fi

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$SRC_DIR"
	mkdir -p `dirname "$INSTALL_DIR"`
}

#
# Install Ruby Dependencies
#
function install_deps()
{
	local packages=`fetch "$RUBY/dependencies" "$PACKAGE_MANAGER"`

	if [[ -n "$packages" ]]; then
		log "Installing dependencies for $RUBY $RUBY_VERSION ..."
		install_packages $packages
	fi

	install_optional_deps
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
	download "$RUBY_URL" "$SRC_DIR/$RUBY_ARCHIVE"
}

#
# Verifies the Ruby archive matches a checksum.
#
function verify_ruby()
{
	if [[ -n "$RUBY_MD5" ]]; then
		log "Verifying $RUBY_ARCHIVE ..."
		verify "$SRC_DIR/$RUBY_ARCHIVE" "$RUBY_MD5"
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
	extract "$SRC_DIR/$RUBY_ARCHIVE" "$SRC_DIR"
}

#
# Download any additional patches
#
function download_patches()
{
	for path in "${PATCHES[@]}"; do
		if [[ "$path" == http:\/\/* || "$path" == https:\/\/* ]]; then
			log "Downloading patch $path ..."
			patch=$(basename "$path")
			download "$path" "$SRC_DIR/$patch"
		fi
	done
}

#
# Apply any additional patches
#
function apply_patches()
{
	for path in "${PATCHES[@]}"; do
		log "Applying patch $(basename $path) ..."
		if [[ "$path" == http:\/\/* || "$path" == https:\/\/* ]]; then
			patch=$(basename "$path")
			path="$SRC_DIR/$patch"
		fi
		patch -p1 -d "$SRC_DIR/$RUBY_SRC_DIR" < "$path"
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
