#!/usr/bin/env bash

RUBY_ARCHIVE="rubinius-$RUBY_VERSION.tar.bz2"
RUBY_SRC_DIR="rubinius-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-http://releases.rubini.us}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_ARCHIVE}"

RUBY_SUFFIX=`gem env \
				| grep ' *- *RUBY EXECUTABLE: *.*' \
				| sed 's/.*: *\(.*\)/\1/' \
				| sed 's/.*ruby\(.*\)/\1/'`
BUNDLERS=("bundle" "bundle$RUBY_SUFFIX")

#
# Check if bundler is installed.
#
function bundler_installed()
{
	for bundler in ${BUNDLERS[@]}; do
		command -v "$bundler" >/dev/null && return 0
	done
	return 1
}

#
# Install optional dependencies for Rubinius.
#
function install_optional_deps()
{
	if ! bundler_installed; then
		log "Installing bundler ..."
		if [[ -w "$(gem env gemdir)" ]]; then gem install bundler
		else                                  sudo gem install bundler
		fi
	fi
	for bundler in ${BUNDLERS[@]}; do
		command -v "$bundler" >/dev/null && {
			BUNDLER="$bundler"
			break
		}
	done
}

#
# Configures Rubinius.
#
function configure_ruby()
{
	log "Bundling rubinius $RUBY_VERSION ..."
	"$BUNDLER" install --path vendor/gems

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
	"$BUNDLER" exec rake build
}

#
# Installs Rubinius into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing rubinius $RUBY_VERSION ..."
	"$BUNDLER" exec rake install
}
