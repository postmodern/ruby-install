#
# Check if we're reinstalling a ruby where another one is already installed
#
function check_reinstall()
{
	if [[ $NO_REINSTALL && -x "$INSTALL_DIR/bin/ruby" ]]; then
		log "Some Ruby is already installed in $INSTALL_DIR and you specified
		to not reinstall it, exiting."
		return 1
	else
		return 0
	fi
}

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$SRC_DIR"
	mkdir -p $(dirname "$INSTALL_DIR")
}

#
# Install Ruby Dependencies
#
function install_deps()
{
	local package_manager

	if   [[ $(type -t apt-get) ]]; then package_manager="apt"
	elif [[ $(type -t yum)     ]]; then package_manager="yum"
	elif [[ $(type -t brew)    ]]; then package_manager="brew"
	elif [[ $(type -t pacman)  ]]; then package_manager="pacman"
	fi

	local packages="$(fetch "$RUBY/dependencies" "$package_manager")"

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
	local md5="$(fetch "$RUBY/md5" "$RUBY_ARCHIVE")"

	if [[ -n "$md5" ]]; then
		log "Verifying $RUBY_ARCHIVE ..."
		verify "$SRC_DIR/$RUBY_ARCHIVE" "$md5"
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
	cd "$SRC_DIR/$RUBY_SRC_DIR"
}

#
# Apply any additional patches
#
function apply_patches()
{
	for path in ${PATCHES[*]}; do
		log "Applying patch $path ..."
		patch -p1 < "$path"
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
