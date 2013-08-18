#!/usr/bin/env bash

PLATFORM="$(uname -sm)"
[[ "$PLATFORM" == "Darwin x86_64" ]] && PLATFORM="Darwin i386"

RUBY_ARCHIVE="MagLev-$RUBY_VERSION.tar.gz"
RUBY_SRC_DIR="MagLev-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-http://glass-downloads.gemstone.com/maglev}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_ARCHIVE}"

#
# Configures MagLev by running ./install.sh.
#
function configure_ruby()
{
	log "Configuring maglev $RUBY_VERSION ..."
	"$SRC_DIR/$RUBY_SRC_DIR/install.sh"
}

#
# Install Maglev into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing maglev $RUBY_VERSION ..."

	# Determine what Maglev named the Gemstone.
	local gs_ver=$(grep GEMSTONE "$SRC_DIR/$RUBY_SRC_DIR/version.txt")
	local gemstone="GemStone-${gs_ver: -5}.${PLATFORM/ /-}"

	log "Installing Gemstone into $SRC_DIR/$gemstone ..."
	ln -fs "$SRC_DIR/$gemstone" "$SRC_DIR/$RUBY_SRC_DIR/gemstone"
	mv "$SRC_DIR/$RUBY_SRC_DIR" "$INSTALL_DIR"
}

#
# Post-install tasks.
#
function post_install()
{	
	log "Symlinking bin/ruby to bin/maglev-ruby ..."
	ln -fs maglev-ruby "$INSTALL_DIR/bin/ruby"
	
	log "Symlinking bin/irb to bin/maglev-irb"
	ln -fs maglev-irb "$INSTALL_DIR/bin/irb"
}
