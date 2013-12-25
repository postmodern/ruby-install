#!/usr/bin/env bash

RUBY_ARCHIVE="rubinius-$RUBY_VERSION.tar.bz2"
RUBY_SRC_DIR="rubinius-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-http://releases.rubini.us}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_ARCHIVE}"

# the ruby executable's name without its full path
RUBY_EXECUTABLE=`gem env \
	| grep ' *- *RUBY EXECUTABLE: *.*' \
	| grep -o '[^\/]*$'`

#
# Check if bundler is installed. Set
# BUNDLER to its executable's name if it
# does and return 0.
# Otherwise return 1.
#
function bundler_installed()
{
	bundlers=("bundle")
	bundler_formatted=`echo "$RUBY_EXECUTABLE" \
		| sed 's/ruby/bundle/'`
	bundlers+=("$bundler_formatted")
	for bundler in ${bundlers[@]}; do
		command -v "$bundler" >/dev/null && {
			BUNDLER="$bundler"
			return 0
		}
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
	bundler_installed || fail "cannot find bundler"
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
