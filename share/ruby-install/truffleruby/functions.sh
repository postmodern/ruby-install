#!/usr/bin/env bash

case "$os_platform" in
	Linux)   truffleruby_platform="linux" ;;
	Darwin)  truffleruby_platform="macos" ;;
	*)       fail "Unsupported platform $os_platform" ;;
esac

case "$os_arch" in
	x86_64)  truffleruby_arch="amd64" ;;
	aarch64) truffleruby_arch="aarch64" ;;
	arm64)   truffleruby_arch="aarch64" ;;
	*)       fail "Unsupported platform $os_arch" ;;
esac

ruby_dir_name="truffleruby-$ruby_version-$truffleruby_platform-$truffleruby_arch"
ruby_archive="${ruby_archive:-$ruby_dir_name.tar.gz}"
ruby_mirror="${ruby_mirror:-https://github.com/oracle/truffleruby/releases/download}"
ruby_url="${ruby_url:-$ruby_mirror/vm-$ruby_version/$ruby_archive}"

#
# Install TruffleRuby into $install_dir.
#
function install_ruby()
{
	if [[ "$install_dir" == '/usr/local' ]]; then
		error "Unsupported see https://github.com/oracle/truffleruby/issues/1389"
		return 1
	fi

	log "Installing truffleruby $ruby_version ..."
	copy_into "$src_dir/$ruby_dir_name" "$install_dir" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	log "Running truffleruby post-install hook ..."
	"$install_dir/lib/truffle/post_install_hook.sh" || return $?
}
