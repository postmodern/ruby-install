#!/usr/bin/env bash

ruby_archive="mruby-$ruby_version.tar.gz"
ruby_src_dir="mruby-$ruby_version"
ruby_mirror="${ruby_mirror:-https://github.com/mruby/mruby/archive}"
ruby_url="${ruby_url:-$ruby_mirror/$ruby_version/$ruby_archive}"

#
# Cleans mruby.
#
function clean_ruby()
{
	log "Cleaning mruby $ruby_version ..."
	make clean || return $?
}

#
# Compile mruby.
#
function compile_ruby()
{
	log "Compiling mruby $ruby_version ..."
	make "${make_opts[@]}" || return $?
}

#
# Install mruby into $install_dir.
#
function install_ruby()
{
	log "Installing mruby $ruby_version ..."
	cp -R "$src_dir/$ruby_src_dir" "$install_dir" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	log "Symlinking bin/ruby to bin/mruby ..."
	ln -fs mruby "$install_dir/bin/ruby" || return $?

	log "Symlinking bin/irb to bin/mirb ..."
	ln -fs mirb "$install_dir/bin/irb" || return $?
}
