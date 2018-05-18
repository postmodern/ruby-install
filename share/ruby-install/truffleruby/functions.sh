#!/usr/bin/env bash

# Check platform
case $(uname) in
	Linux) platform=linux ;;
	Darwin) platform=macos ;;
	*) fail "unknown platform $(uname)" ;;
esac

# Check architecture
case $(uname -m) in
	x86_64) arch=amd64 ;;
	*) fail "unknown architecture $(uname -m)" ;;
esac

ruby_dir_name="truffleruby-$ruby_version-$platform-$arch"
ruby_archive="$ruby_dir_name.tar.gz"
ruby_mirror="${ruby_mirror:-https://github.com/oracle/truffleruby/releases/download}"
ruby_url="${ruby_url:-$ruby_mirror/vm-$ruby_version/$ruby_archive}"

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
