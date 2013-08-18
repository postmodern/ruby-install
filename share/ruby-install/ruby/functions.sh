#!/usr/bin/env bash

RUBY_VERSION_FAMILY="${RUBY_VERSION:0:3}"
RUBY_ARCHIVE="ruby-$RUBY_VERSION.tar.bz2"
RUBY_SRC_DIR="ruby-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-ftp://ftp.ruby-lang.org/pub/ruby}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_VERSION_FAMILY/$RUBY_ARCHIVE}"

RUBYGEMS_VERSION="2.0.3"
RUBYGEMS_ARCHIVE="rubygems-$RUBYGEMS_VERSION.tgz"
RUBYGEMS_SRC_DIR="rubygems-$RUBYGEMS_VERSION"
RUBYGEMS_URL="http://production.cf.rubygems.org/rubygems/$RUBYGEMS_ARCHIVE"
RUBYGEMS_MD5="$(fetch "$RUBY/md5" "$RUBYGEMS_ARCHIVE")"

if [[ "$RUBY_VERSION_FAMILY" == "1.8" ]]; then
	PATCHES+=("$RUBY_DIR"/patches/1.8/*.patch)
fi

#
# Configures Ruby.
#
function configure_ruby()
{
	log "Configuring ruby $RUBY_VERSION ..."

	if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
		./configure --prefix="$INSTALL_DIR" \
			    --with-opt-dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm):$(brew --prefix libffi)" \
			    $CONFIGURE_OPTS
	else
		./configure --prefix="$INSTALL_DIR" $CONFIGURE_OPTS
	fi
}

#
# Compiles Ruby.
#
function compile_ruby()
{
	log "Compiling ruby $RUBY_VERSION ..."
	make
}

#
# Installs Ruby into $INSTALL_DIR
#
function install_ruby()
{
	log "Installing ruby $RUBY_VERSION ..."
	make install
}

function post_install()
{
	if [[ "$RUBY_VERSION_FAMILY" == "1.8" ]]; then
		log "Downloading $RUBYGEMS_URL into $SRC_DIR ..."
		download "$RUBYGEMS_URL" "$SRC_DIR"

		log "Verifying $RUBYGEMS_ARCHIVE ..."
		verify "$SRC_DIR/$RUBYGEMS_ARCHIVE" "$RUBYGEMS_MD5"

		log "Extracting $RUBYGEMS_ARCHIVE ..."
		extract "$SRC_DIR/$RUBYGEMS_ARCHIVE"

		log "Installing rubygems $RUBYGEMS_VERSION ..."
		cd "$SRC_DIR/$RUBYGEMS_SRC_DIR"
		"$INSTALL_DIR/bin/ruby" setup.rb
	fi
}
