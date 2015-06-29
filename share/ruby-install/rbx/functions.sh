#!/usr/bin/env bash

ruby_archive="rubinius-$ruby_version.tar.bz2"
ruby_src_dir="rubinius-$ruby_version"
ruby_mirror="${ruby_mirror:-http://releases.rubini.us}"
ruby_url="${ruby_url:-$ruby_mirror/$ruby_archive}"

#
# Install gems needed by Rubinius.
#
function install_gems()
{
	export PATH="$PWD/vendor/gems/bin:$PATH"
	export GEM_HOME="$PWD/vendor/gems"
	unset RUBYGEMS_GEMDEPS

	log "Bundling rubinius $ruby_version ..."
	gem install --no-format-executable bundler || return $?
	bundle install || return $?
}

#
# Configures Rubinius.
#
function configure_ruby()
{
	install_gems

	local opt_dir

	log "Configuring rubinius $ruby_version ..."
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
# Cleans Rubinius.
#
function clean_ruby()
{
	log "Cleaning rubinius $ruby_version ..."
	bundle exec rake clean || return $?
}

#
# Compiles Rubinius.
#
function compile_ruby()
{
	log "Compiling rubinius $ruby_version ..."
	bundle exec rake build || return $?
}

#
# Installs Rubinius into $install_dir.
#
function install_ruby()
{
	log "Installing rubinius $ruby_version ..."
	bundle exec rake install || return $?
}
