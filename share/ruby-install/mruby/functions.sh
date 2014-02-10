#!/usr/bin/env bash

RUBY_ARCHIVE="mruby-$RUBY_VERSION.tar.gz"
RUBY_SRC_DIR="mruby-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-https://github.com/mruby/mruby/archive}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_VERSION/$RUBY_ARCHIVE}"

#
# Compile mruby.
#
function compile_ruby()
{
	log "Compiling mruby $RUBY_VERSION ..."
	make || return $?
}

#
# Install mruby into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing mruby $RUBY_VERSION ..."
	mv "$SRC_DIR/$RUBY_SRC_DIR" "$INSTALL_DIR" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	log "Symlinking bin/ruby to bin/mruby ..."
	ln -fs mruby "$INSTALL_DIR/bin/ruby" || return $?

	log "Symlinking bin/irb to bin/mirb ..."
	ln -fs mirb "$INSTALL_DIR/bin/irb" || return $?
}
