#!/usr/bin/env bash

ruby_archive="jruby-bin-$ruby_version.tar.gz"
ruby_dir_name="jruby-$ruby_version"
ruby_mirror="${ruby_mirror:-https://s3.amazonaws.com/jruby.org/downloads}"
ruby_url="${ruby_url:-$ruby_mirror/$ruby_version/$ruby_archive}"

#
# Install JRuby into $install_dir.
#
function install_ruby()
{
	log "Installing jruby $ruby_version ..."
	cp -R "$src_dir/$ruby_dir_name" "$rubies_dir/" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	log "Symlinking bin/ruby to bin/jruby ..."
	ln -fs jruby "$install_dir/bin/ruby" || return $?

	if ! command -v java >/dev/null; then
		warn "In order to use JRuby you must install OracleJDK:"
		warn "  http://www.oracle.com/technetwork/java/javase/downloads/index.html"
	fi
}
