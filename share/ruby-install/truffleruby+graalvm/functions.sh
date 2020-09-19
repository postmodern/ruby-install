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
	mkdir "$install_dir" || return $?
	cp -R "$src_dir/$ruby_dir_name" "$install_dir/graalvm" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	cd "$install_dir/graalvm" || return $?
	if [[ "$platform" == "macos" ]]; then
	  cd Contents/Home || return $?
	fi

	log "Installing the Ruby component ..."
	bin/gu install ruby || return $?

	local ruby_home
	ruby_home=$(bin/ruby -e 'print RbConfig::CONFIG["prefix"]') || return $?

	# Make gu available in PATH (useful to install other languages)
	ln -s "$PWD/bin/gu" "$ruby_home/bin/gu" || return $?

	cd "$install_dir" || return $?
	ln -s "${ruby_home#"$install_dir/"}/bin" . || return $?

	log "Running truffleruby post-install hook ..."
	"$ruby_home/lib/truffle/post_install_hook.sh" || return $?
}
