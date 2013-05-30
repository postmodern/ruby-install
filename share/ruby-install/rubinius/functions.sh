#!/usr/bin/env bash

RUBY_SRC_DIR="rubinius-release-$RUBY_VERSION"
RUBY_URL="https://github.com/rubinius/rubinius/archive/release-$RUBY_VERSION.tar.gz"

#
# Install optional dependencies for Rubinius.
#
function install_optional_deps()
{
	if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
		# attempt to install llvm-3.0-dev
		(sudo apt-get install -y llvm-3.0-dev && sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-3.0 30) || true
	fi
}

#
# Configures Rubinius.
#
function configure_ruby()
{
	log "Configuring rubinius $RUBY_VERSION ..."

	if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
		./configure --prefix="$INSTALL_DIR" \
			    --with-opt-dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm):$(brew --prefix libffi)" \
			    $CONFIGURE_OPTS
	else
		./configure --prefix="$INSTALL_DIR" $CONFIGURE_OPTS
	fi
}

#
# Compiles Rubinius.
#
function compile_ruby()
{
	log "Compiling rubinius $RUBY_VERSION ..."
	rake build
}

#
# Installs Rubinius into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing rubinius $RUBY_VERSION ..."
	rake install
}
