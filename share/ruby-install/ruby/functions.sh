#!/usr/bin/env bash

if [[ $binary_install -eq 1 ]]; then
	ruby_archive="ruby-bin-$ruby_version.tar.bz2"
	ruby_src_dir="ruby-$ruby_version"
	ruby_mirror="${ruby_mirror:-https://rvm.io/binaries}"
	ruby_url="${ruby_url:-$ruby_mirror/$system_name/$system_version/$system_arch/ruby-$ruby_version.tar.bz2}"
else
	ruby_archive="ruby-$ruby_version.tar.bz2"
	ruby_src_dir="ruby-$ruby_version"
	ruby_version_family="${ruby_version:0:3}"
	ruby_mirror="${ruby_mirror:-http://cache.ruby-lang.org/pub/ruby}"
	ruby_url="${ruby_url:-$ruby_mirror/$ruby_version_family/$ruby_archive}"
fi

#
# Configures Ruby.
#
function configure_ruby()
{
	if [[ $binary_install -eq 1 ]]; then
		return
	fi

	log "Configuring ruby $ruby_version ..."
	case "$package_manager" in
		brew)
			./configure --prefix="$install_dir" \
				    --with-opt-dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm):$(brew --prefix libffi)" \
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
# Cleans Ruby.
#
function clean_ruby()
{
	if [[ $binary_install -eq 1 ]]; then
		return
	fi

	log "Cleaning ruby $ruby_version ..."
	make clean || return $?
}

#
# Compiles Ruby.
#
function compile_ruby()
{
	if [[ $binary_install -eq 1 ]]; then
		return
	fi

	log "Compiling ruby $ruby_version ..."
	make "${make_opts[@]}" || return $?
}

#
# Installs Ruby into $install_dir
#
function install_ruby()
{
	log "Installing ruby $ruby_version ..."

	if [[ $binary_install -eq 1 ]]; then
		cp -R "$src_dir/$ruby_src_dir" "$install_dir" || return $?
	else
		make install || return $?
	fi
}
