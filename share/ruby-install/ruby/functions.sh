#!/usr/bin/env bash

ruby_version_family="${ruby_version:0:3}"

if [[ "$ruby_version_family" < "2.0" ]]; then
	ruby_archive_ext="tar.bz2"
else
	ruby_archive_ext="tar.xz"
fi

ruby_archive="${ruby_archive:-ruby-$ruby_version.$ruby_archive_ext}"
ruby_dir_name="ruby-$ruby_version"
ruby_mirror="${ruby_mirror:-https://cache.ruby-lang.org/pub/ruby}"
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
	local openssl_dir

	log "Configuring ruby $ruby_version ..."
	case "$package_manager" in
		brew)
			opt_dir="$(brew --prefix readline):$(brew --prefix libyaml)"
			openssl_dir="$(brew --prefix "openssl@${openssl_version}")"

			if [[ "${ruby_dependencies[*]}" == *"gdbm"* ]]; then
				opt_dir="${opt_dir}:$(brew --prefix gdbm)"
			fi

			if [[ "${ruby_dependencies[*]}" == *"jemalloc"* ]]; then
				opt_dir="${opt_dir}:$(brew --prefix jemalloc)"
			fi
			;;
		port)
			opt_dir="/opt/local"
			openssl_dir="/opt/local"
			;;
	esac

	run ./configure --prefix="$install_dir" \
			"${opt_dir:+--with-opt-dir="$opt_dir"}" \
			"${openssl_dir:+--with-openssl-dir="$openssl_dir"}" \
			"${configure_opts[@]}" || return $?
}

#
# Cleans Ruby.
#
function clean_ruby()
{
	log "Cleaning ruby $ruby_version ..."
	run make clean || return $?
}

#
# Compiles Ruby.
#
function compile_ruby()
{
	log "Compiling ruby $ruby_version ..."
	run make -j "${make_jobs:-$(cpu_count)}" || return $?
}

#
# Installs Ruby into $install_dir
#
function install_ruby()
{
	log "Installing ruby $ruby_version ..."
	run make install || return $?
}
