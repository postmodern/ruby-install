#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/ruby-install.sh

function setUp()
{
	ruby="truffleruby-graalvm"
	ruby_version="23.1.2"
}

function test_when_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "make gcc zlib1g-dev libssl-dev libxml2 libyaml-dev"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "make gcc zlib-devel openssl-devel libxml2 libyaml-devel"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	package_manager="yum"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "make gcc zlib-devel openssl-devel libxml2 libyaml-devel"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_port()
{
	local original_package_manager="$package_manager"
	package_manager="port"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "openssl libyaml"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_brew()
{
	local original_package_manager="$package_manager"
	package_manager="brew"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "openssl@1.1 libyaml"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pacman()
{
	local original_package_manager="$package_manager"
	package_manager="pacman"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "make gcc zlib openssl libxml2 libyaml"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	package_manager="zypper"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "make gcc zlib-devel libopenssl-devel libxml2 libyaml-devel"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pkg()
{
	local original_package_manager="$package_manager"
	package_manager="pkg"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "gmake gcc openssl libxml2 libyaml"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "base-devel openssl-devel zlib-devel libxml2 libyaml-devel"

	package_manager="$original_package_manager"
}

function tearDown()
{
	unset ruby ruby_version ruby_dependencies
}

SHUNIT_PARENT=$0 . $SHUNIT2
