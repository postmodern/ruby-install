#!/usr/bin/env bash

RUBY_ARCHIVE="rubinius-$RUBY_VERSION.tar.bz2"
RUBY_SRC_DIR="rubinius-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-http://releases.rubini.us}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_ARCHIVE}"

#
# Install optional dependencies for Rubinius.
#
function install_optional_deps()
{
	if ! command -v bundle >/dev/null; then
		log "Installing bundler ..."
		if [[ -w "$(gem env gemdir)" ]]; then gem install bundler
		else                                  sudo gem install bundler
		fi
	fi
}

#
# Configures Rubinius.
#
function configure_ruby()
{
	log "Bundling rubinius $RUBY_VERSION ..."
	bundle install --path vendor/gems

	log "Configuring rubinius $RUBY_VERSION ..."
	if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
		./configure --prefix="$INSTALL_DIR" \
			    --with-opt-dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm)" \
			    "${CONFIGURE_OPTS[@]}"
	else
		./configure --prefix="$INSTALL_DIR" "${CONFIGURE_OPTS[@]}"
	fi
}

#
# Compiles Rubinius.
#
function compile_ruby()
{
	log "Compiling rubinius $RUBY_VERSION ..."
	bundle exec rake build
}

#
# Installs Rubinius into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing rubinius $RUBY_VERSION ..."
	bundle exec rake install
}
