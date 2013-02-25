#!/usr/bin/env bash

RUBY_ARCHIVE="ruby-$RUBY_VERSION.tar.gz"
RUBY_SRC_DIR="ruby-$RUBY_VERSION"
RUBY_URL="http://ftp.ruby-lang.org/pub/ruby/1.9/$RUBY_ARCHIVE"

DEPENDENCIES=(
	[apt]="build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev"
	[yum]="gcc automake zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel"
	[brew]="openssl readline libyaml gdbm libffi"
)

#
# Configures Ruby.
#
function configure_ruby() {
	log "Configuring ruby $RUBY_VERSION ..."

	if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
		./configure --prefix="$INSTALL_DIR" \
			    --with-openssl-dir=`brew --prefix openssl` \
			    --with-readline-dir=`brew --prefix readline` \
			    --with-yaml-dir=`brew --prefix yaml` \
			    --with-gdbm-dir=`brew --prefix gdbm` \
			    --with-libffi-dir=`brew --prefix libffi` \
			    $CONFIGURE_OPTS
	else
		./configure --prefix="$INSTALL_DIR" $CONFIGURE_OPTS
	fi
}

#
# Compiles Ruby.
#
function compile_ruby() {
	log "Compiling ruby $RUBY_VERSION ..."
	make
}

#
# Installs Ruby into $INSTALL_DIR
#
function install_ruby() {
	log "Installing ruby $RUBY_VERSION ..."
	make install
}
