#!/usr/bin/env bash

platform=$(platform) || return $?
graalvm_platform="${platform/macos/darwin}"
arch=$(architecture) || return $?

ruby_dir_name="graalvm-ce-java8-$ruby_version"
ruby_archive="graalvm-ce-java8-$graalvm_platform-$arch-$ruby_version.tar.gz"
ruby_mirror="${ruby_mirror:-https://github.com/graalvm/graalvm-ce-builds/releases/download}"
ruby_url="${ruby_url:-$ruby_mirror/vm-$ruby_version/$ruby_archive}"

#
# Install GraalVM into $install_dir.
#
function install_ruby()
{
	log "Installing GraalVM $ruby_version ..."
	cp -R "$src_dir/$ruby_dir_name" "$install_dir" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	log "Installing the Ruby component ..."
	"$install_dir/bin/gu" install ruby || return $?

	log "Running truffleruby post-install hook ..."
	local ruby_home
	ruby_home=$("$install_dir/bin/ruby" -e 'print RbConfig::CONFIG["prefix"]')
	"$ruby_home/lib/truffle/post_install_hook.sh" || return $?
}
