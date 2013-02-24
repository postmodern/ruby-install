#!/bin/bash

RUBY_ARCHIVE="jruby-bin-$RUBY_VERSION.tar.gz"
RUBY_SRC_DIR="jruby-$RUBY_VERSION"
RUBY_URL="http://jruby.org.s3.amazonaws.com/downloads/$RUBY_VERSION/$RUBY_ARCHIVE"

DEPENDENCIES=(
  [apt]="openjdk-7-jdk"
  [yum]="java-1.7.0-openjdk"
)

#
# Install JRuby into $INSTALL_DIR.
#
function install_ruby() {
	log "Installing jruby $RUBY_VERSION ..."
	cp -r "$SRC_DIR/$RUBY_SRC_DIR/*" "$INSTALL_DIR"
}

#
# Post-install tasks.
#
function post_install() {
	log "Symlinking bin/ruby to bin/jruby ..."
	ln -fs jruby "$INSTALL_DIR/bin/ruby"

	if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
		warning "In order to use JRuby you must install OracleJDK:"
		warning "  http://www.oracle.com/technetwork/java/javase/downloads/index.html"
	fi
}
