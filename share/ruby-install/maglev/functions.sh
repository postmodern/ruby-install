#!/usr/bin/env bash

PLATFORM="$(uname -sm)"
[ $PLATFORM="Darwin x86_64" ] && PLATFORM="Darwin i386"

RUBY_ARCHIVE="MagLev-$RUBY_VERSION.tar.gz"
RUBY_URL="http://glass-downloads.gemstone.com/maglev/$RUBY_ARCHIVE"

function configure_ruby() { return; }

function compile_ruby() { return; }

#
# Install Maglev into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing maglev $RUBY_VERSION ..."
	"$SRC_DIR/$RUBY_SRC_DIR/install.sh"

	# Determine what Maglev named the Gemstone.
	gs_ver=$(grep GEMSTONE "$SRC_DIR/$RUBY_SRC_DIR/version.txt")
	gemstone="GemStone-${gs_ver: -5}.${PLATFORM/ /-}"

	log "Installing Gemstone into $SRC_DIR/$gemstone ..."
	ln -fs "$gemstone" "$SRC_DIR/gemstone"
	mv "$SRC_DIR/$RUBY_SRC_DIR" "$(dirname $INSTALL_DIR)"
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
