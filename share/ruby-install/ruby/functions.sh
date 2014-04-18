#!/usr/bin/env bash

ruby_version_family="${ruby_version:0:3}"
ruby_archive="ruby-$ruby_version.tar.bz2"
ruby_src_dir="ruby-$ruby_version"
ruby_mirror="${ruby_mirror:-http://cache.ruby-lang.org/pub/ruby}"
ruby_url="${ruby_url:-$ruby_mirror/$ruby_version_family/$ruby_archive}"

#
# Configures Ruby.
#
function configure_ruby()
{
	if [[ ! -s configure || configure.in -nt configure ]]; then
		log "Regenerating ./configure script ..."
		autoreconf || return $?
	fi

	local opt_dir

	log "Configuring ruby $ruby_version ..."
	case "$package_manager" in
		brew)
			opt_dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm)"
			;;
		port)
			opt_dir="/opt/local"
			;;
	esac

	./configure --prefix="$install_dir" \
		    "${opt_dir:+--with-opt-dir="$opt_dir"}" \
		    "${configure_opts[@]}" || return $?
}

#
# Cleans Ruby.
#
function clean_ruby()
{
	log "Cleaning ruby $ruby_version ..."
	make clean || return $?
}

#
# Compiles Ruby.
#
function compile_ruby()
{
	log "Compiling ruby $ruby_version ..."
	make "${make_opts[@]}" || return $?
}

#
# Installs Ruby into $install_dir
#
function install_ruby()
{
	log "Installing ruby $ruby_version ..."
	make install || return $?
}
