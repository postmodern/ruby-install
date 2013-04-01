#!/usr/bin/env bash

RUBY_ARCHIVE="rubinius-$RUBY_VERSION.tar.gz"
RUBY_SRC_DIR="rubinius-release-$RUBY_VERSION"
RUBY_URL="https://github.com/rubinius/rubinius/archive/release-$RUBY_VERSION.tar.gz"

#
# Install build dependencies for Rubinius.
#
function install_dependencies() {
	log "Installing build dependencies ..."

	case "$PACKAGE_MANAGER" in
		apt)
			apt-get install -y gcc g++ automake flex bison ruby-dev rake \
				           zlib1g-dev libyaml-dev libssl-dev \
					   libgdbm-dev libreadline-dev libncurses5-dev

			(apt-get install -y llvm-3.0-dev && update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-3.0 30) || true
			;;
		yum)
			yum install -y gcc gcc-c++ automake flex bison ruby-devel \
			               rubygems rubygem-rake llvm-devel zlib-devel \
				       libyaml-devel openssl-devel gdbm-devel \
				       readline-devel ncurses-devel
			;;
		brew)	brew install libyaml gdbm || true ;;
	esac
}

#
# Configures Rubinius.
#
function configure_ruby() {
	log "Configuring rubinius $RUBY_VERSION ..."
	./configure --prefix="$INSTALL_DIR" $CONFIGURE_OPTS
}

#
# Compiles Rubinius.
#
function compile_ruby() {
	log "Compiling rubinius $RUBY_VERSION ..."
	rake build
}

#
# Installs Rubinius into $INSTALL_DIR.
#
function install_ruby() {
	log "Installing rubinius $RUBY_VERSION ..."
	rake install
}
