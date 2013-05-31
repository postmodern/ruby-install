#!/usr/bin/env bash

RUBY_ARCHIVE="MagLev-$RUBY_VERSION.tar.gz"
RUBY_URL="http://glass-downloads.gemstone.com/maglev/$RUBY_ARCHIVE"

function extract_ruby() { return; }

function configure_ruby() { return; }

function compile_ruby() { return; }

#
# Install Maglev into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing maglev $RUBY_VERSION ..."
	mkdir "$INSTALL_DIR"
	tar -xzf "$SRC_DIR/$RUBY_ARCHIVE" -C "$INSTALL_DIR" \
		                          --strip-components=1
	cd "$INSTALL_DIR"
	sh "install.sh"
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
