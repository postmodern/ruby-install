#!/usr/bin/env bash

platform=$(platform) || return $?
arch=$(architecture) || return $?

if [[ "$ruby_version" == "head" ]]; then
	local head_platform
	case "$platform" in
		linux) head_platform="ubuntu-18.04" ;;
		macos) head_platform="macos-latest" ;;
	esac
	ruby_dir_name="truffleruby-head"
	ruby_archive="truffleruby-head-$head_platform.tar.gz"
	ruby_mirror="${ruby_mirror:-https://github.com/ruby/truffleruby-dev-builder/releases/latest/download}"
	ruby_url="${ruby_url:-$ruby_mirror/$ruby_archive}"
else
	ruby_dir_name="truffleruby-$ruby_version-$platform-$arch"
	ruby_archive="$ruby_dir_name.tar.gz"
	ruby_mirror="${ruby_mirror:-https://github.com/oracle/truffleruby/releases/download}"
	ruby_url="${ruby_url:-$ruby_mirror/vm-$ruby_version/$ruby_archive}"
fi

#
# Install TruffleRuby into $install_dir.
#
function install_ruby()
{
	log "Installing truffleruby $ruby_version ..."
	cp -R "$src_dir/$ruby_dir_name" "$install_dir" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	log "Running truffleruby post-install hook ..."
	"$install_dir/lib/truffle/post_install_hook.sh" || return $?
}
