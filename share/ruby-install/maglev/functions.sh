#!/usr/bin/env bash

PLATFORM="$(uname -sm | tr ' ' '-')"
[ $PLATFORM="Darwin-x86_64" ] && PLATFORM="Darwin-i386"

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

	# Determine the Gemstone name with code adapted from Maglev's update.sh.
	gs_ver=$(grep GEMSTONE "$SRC_DIR/$RUBY_SRC_DIR/version.txt" | cut -f2 -d-)
	gemstone="GemStone-$gs_ver.$PLATFORM"

	# Move the Gemstone from $SRC_DIR to $RUBY_SRC_DIR and symlink gemstone.
	mv "$SRC_DIR/$gemstone" "$SRC_DIR/$RUBY_SRC_DIR"
	ln -fs "$gemstone" "$SRC_DIR/$RUBY_SRC_DIR/gemstone"

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
