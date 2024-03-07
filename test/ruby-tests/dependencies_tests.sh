#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/ruby-install.sh

function setUp()
{
	ruby="ruby"
	ruby_version="3.2.0"
}

function test_when_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "xz-utils build-essential bison zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "xz gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	package_manager="yum"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "xz gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pacman()
{
	local original_package_manager="$package_manager"
	package_manager="pacman"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "xz gcc make bison zlib ncurses openssl readline libyaml gdbm libffi"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	package_manager="zypper"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "xz gcc make automake zlib-devel libyaml-devel libopenssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pkg()
{
	local original_package_manager="$package_manager"
	package_manager="pkg"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "openssl readline libyaml gdbm libffi"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "base-devel openssl-devel zlib-devel libyaml-devel gdbm-devel readline-devel ncurses-devel libffi-develesac"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_brew_and_ruby_version_is_less_than_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="3.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "1.1" \
		     "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "automake bison readline libyaml gdbm libffi openssl@1.1"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_brew_and_ruby_version_is_greater_equal_to_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="3.1.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "3" \
		     "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "automake bison readline libyaml gdbm libffi openssl@3"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_port_and_ruby_version_is_less_than_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="port"
	ruby_version="3.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "1.1" \
		     "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "automake bison readline libyaml gdbm libffi openssl11"

	package_manager="$original_package_manager"
}

function test_package_manager_is_port_and_ruby_version_is_greater_equal_to_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="port"
	ruby_version="3.1.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "3" \
		     "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "automake bison readline libyaml gdbm libffi openssl3"

	package_manager="$original_package_manager"
}

function tearDown()
{
	unset ruby ruby_version ruby_dependencies openssl_version
}

SHUNIT_PARENT=$0 . $SHUNIT2
