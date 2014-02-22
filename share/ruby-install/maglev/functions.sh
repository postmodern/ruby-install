#!/usr/bin/env bash

platform="$(uname -sm)"
[[ "$platform" == "Darwin x86_64" ]] && platform="Darwin i386"

ruby_archive="MagLev-$ruby_version.tar.gz"
ruby_src_dir="MagLev-$ruby_version"
ruby_mirror="${ruby_mirror:-http://glass-downloads.gemstone.com/maglev}"
ruby_url="${ruby_url:-$ruby_mirror/$ruby_archive}"

#
# Configures MagLev by running ./install.sh.
#
function configure_ruby()
{
	log "Configuring maglev $ruby_version ..."
	"$src_dir/$ruby_src_dir/install.sh" || return $?
}

#
# Install Maglev into $install_dir.
#
function install_ruby()
{
	log "Installing maglev $ruby_version ..."

	# Determine what Maglev named the Gemstone.
	local gs_ver=$(grep GEMSTONE "$src_dir/$ruby_src_dir/version.txt" || return $?)
	local gemstone="GemStone-${gs_ver: -5}.${platform/ /-}"

	log "Installing Gemstone into $src_dir/$gemstone ..."
	ln -fs "$src_dir/$gemstone" "$src_dir/$ruby_src_dir/gemstone" || return $?
	cp -R "$src_dir/$ruby_src_dir" "$install_dir" || return $?
}

#
# Post-install tasks.
#
function post_install()
{	
	log "Symlinking bin/ruby to bin/maglev-ruby ..."
	ln -fs maglev-ruby "$install_dir/bin/ruby" || return $?
	
	log "Symlinking bin/irb to bin/maglev-irb"
	ln -fs maglev-irb "$install_dir/bin/irb" || return $?
}
