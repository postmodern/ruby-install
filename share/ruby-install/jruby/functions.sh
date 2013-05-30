#!/usr/bin/env bash

RUBY_ARCHIVE="jruby-bin-$RUBY_VERSION.tar.gz"
RUBY_URL="http://jruby.org.s3.amazonaws.com/downloads/$RUBY_VERSION/$RUBY_ARCHIVE"

function extract_ruby() { return; }

function configure_ruby() { return; }

function compile_ruby() { return; }

#
# Install JRuby into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing jruby $RUBY_VERSION ..."
	mkdir "$INSTALL_DIR"
	tar -xzf "$SRC_DIR/$RUBY_ARCHIVE" -C "$INSTALL_DIR" \
		                          --strip-components=1
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
