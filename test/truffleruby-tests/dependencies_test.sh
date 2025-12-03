#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/ruby-install.sh

function setUp()
{
	ruby="truffleruby"
	ruby_version="23.1.2"
}

function test_when_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib1g-dev ca-certificates libssl-dev libyaml-dev" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib-devel ca-certificates openssl-devel libyaml-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	package_manager="yum"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib-devel ca-certificates openssl-devel libyaml-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_port()
{
	local original_package_manager="$package_manager"
	package_manager="port"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "curl-ca-bundle openssl libyaml" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_brew()
{
	local original_package_manager="$package_manager"
	package_manager="brew"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "ca-certificates openssl@3 libyaml" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pacman()
{
	local original_package_manager="$package_manager"
	package_manager="pacman"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib ca-certificates openssl libyaml" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	package_manager="zypper"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib-devel ca-certificates libopenssl-devel libyaml-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pkg()
{
	local original_package_manager="$package_manager"
	package_manager="pkg"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "gmake gcc ca-certificates openssl libyaml" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "base-devel zlib-devel ca-certificates openssl-devel libyaml-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_at_least_33_and_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"
	ruby_version="33.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib1g-dev ca-certificates" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_at_least_33_and_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"
	ruby_version="33.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib-devel ca-certificates" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_at_least_33_and_package_manager_is_pacman()
{
	local original_package_manager="$package_manager"
	package_manager="pacman"
	ruby_version="33.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "make gcc zlib ca-certificates" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_at_least_33_and_package_manager_is_port()
{
	local original_package_manager="$package_manager"
	package_manager="port"
	ruby_version="33.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "curl-ca-bundle" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_at_least_33_and_package_manager_is_brew()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="33.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "ca-certificates" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_at_least_33_and_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"
	ruby_version="33.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "base-devel zlib-devel ca-certificates" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function tearDown()
{
	unset ruby ruby_version ruby_dependencies
}

SHUNIT_PARENT=$0 . $SHUNIT2
