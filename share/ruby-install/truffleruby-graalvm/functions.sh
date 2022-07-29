#!/usr/bin/env bash

case "$os_platform" in
	Linux)   graalvm_platform="linux" ;;
	Darwin)  graalvm_platform="darwin" ;;
	*)       fail "Unsupported platform $os_platform" ;;
esac

case "$os_arch" in
	x86_64)  graalvm_arch="amd64" ;;
	aarch64) graalvm_arch="aarch64" ;;
	arm64)   graalvm_arch="aarch64" ;;
	*)       fail "Unsupported platform $os_arch" ;;
esac

ruby_dir_name="graalvm-ce-java11-$ruby_version"
ruby_archive="${ruby_archive:-graalvm-ce-java11-$graalvm_platform-$graalvm_arch-$ruby_version.tar.gz}"
ruby_mirror="${ruby_mirror:-https://github.com/graalvm/graalvm-ce-builds/releases/download}"
ruby_url="${ruby_url:-$ruby_mirror/vm-$ruby_version/$ruby_archive}"

#
# Install GraalVM into $install_dir.
#
function install_ruby()
{
	if [[ "$install_dir" == '/usr/local' ]]; then
		error "Unsupported see https://github.com/oracle/truffleruby/issues/1389"
		return 1
	fi

	log "Installing GraalVM $ruby_version ..."
	copy_into "$src_dir/$ruby_dir_name" "$install_dir/graalvm" || return $?
}

#
# Post-install tasks.
#
function post_install()
{
	cd "$install_dir/graalvm" || return $?

	if [[ "$graalvm_platform" == "darwin" ]]; then
		cd Contents/Home || return $?
	fi

	log "Installing the Ruby component ..."
	./bin/gu install ruby || return $?

	local ruby_home="$(./bin/ruby -e 'print RbConfig::CONFIG["prefix"]')"

	if [[ -z "$ruby_home" ]]; then
		error "Could not determine TruffleRuby home"
		return 1
	fi

	# Make gu available in PATH (useful to install other languages)
	ln -fs "$PWD/bin/gu" "$ruby_home/bin/gu" || return $?

	cd "$install_dir" || return $?
	ln -fs "${ruby_home#"$install_dir/"}/bin" . || return $?

	log "Running truffleruby post-install hook ..."
	"$ruby_home/lib/truffle/post_install_hook.sh" || return $?
}
