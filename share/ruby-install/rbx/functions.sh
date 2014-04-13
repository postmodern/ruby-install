#!/usr/bin/env bash

ruby_archive="rubinius-$ruby_version.tar.bz2"
ruby_src_dir="rubinius-$ruby_version"
ruby_mirror="${ruby_mirror:-http://releases.rubini.us}"
ruby_url="${ruby_url:-$ruby_mirror/$ruby_archive}"

#
# Install optional dependencies for Rubinius.
#
function install_optional_deps()
{
	if ! command -v bundle >/dev/null; then
		log "Installing bundler ..."
		GEM_HOME=$src_dir/ gem install bundler || return $?
	fi
}

#
# Configures Rubinius.
#
function configure_ruby()
{
	export GEM_HOME="$PWD/vendor/gems"

	log "Bundling rubinius $ruby_version ..."
	gem install bundler || return $?
	./vendor/gems/bin/bundle install || return $?

	log "Configuring rubinius $ruby_version ..."
	case "$package_manager" in
		brew)
			./configure --prefix="$install_dir" \
				    --with-opt-dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm)" \
				    "${configure_opts[@]}" || return $?
			;;
		port)
			./configure --prefix="$install_dir" \
				    --with-opt-dir=/opt/local \
				    "${configure_opts[@]}" || return $?
			;;
		*)
			./configure --prefix="$install_dir" \
				    "${configure_opts[@]}" || return $?
			;;
	esac
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
