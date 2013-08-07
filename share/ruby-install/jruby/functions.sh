#!/usr/bin/env bash

RUBY_ARCHIVE="jruby-bin-$RUBY_VERSION.tar.gz"
RUBY_SRC_DIR="jruby-$RUBY_VERSION"
RUBY_MIRROR="${RUBY_MIRROR:-http://jruby.org.s3.amazonaws.com/downloads}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_VERSION/$RUBY_ARCHIVE}"

#
# Install JRuby into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing jruby $RUBY_VERSION ..."
	mv "$SRC_DIR/$RUBY_SRC_DIR" "$INSTALL_DIR"
}

#
# Post-install tasks.
#
function post_install()
{
	log "Symlinking bin/ruby to bin/jruby ..."
	ln -fs jruby "$INSTALL_DIR/bin/ruby"

	if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
		warn "In order to use JRuby you must install OracleJDK:"
		warn "  http://www.oracle.com/technetwork/java/javase/downloads/index.html"
	fi
}
