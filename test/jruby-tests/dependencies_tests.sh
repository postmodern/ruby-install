#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/ruby-install.sh

function setUp()
{
	ruby="jruby"
	ruby_version="9.4.3.0"
}

function test_when_java_is_not_installed_and_package_manager_is_apt()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="apt"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "default-jre"

	package_manager="$original_package_manager"
}

function test_when_java_is_not_installed_and_package_manager_is_dnf()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="dnf"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "java-latest-openjdk"

	package_manager="$original_package_manager"
}

function test_when_java_is_not_installed_and_package_manager_is_yum()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="yum"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "java-latest-openjdk"

	package_manager="$original_package_manager"
}

function test_when_java_is_not_installed_and_package_manager_is_pacman()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="pacman"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "jre21-openjdk"

	package_manager="$original_package_manager"
}

function test_when_java_is_not_installed_and_package_manager_is_zypper()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="zypper"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "java-21-openjdk"

	package_manager="$original_package_manager"
}

function test_when_java_is_not_installed_and_package_manager_is_pkg()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="pkg"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "openjdk21-jre"

	package_manager="$original_package_manager"
}

function test_when_java_is_not_installed_and_package_manager_is_xbps()
{
	command -v java >/dev/null && return

	local original_package_manager="$package_manager"
	package_manager="xbps"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     "openjdk-jre"

	package_manager="$original_package_manager"
}

function test_when_java_is_installed()
{
	command -v java >/dev/null || return

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did accidentally populated \$ruby_dependencies" \
		     "${ruby_dependencies[*]}" \
		     ""
}

function tearDown()
{
	unset ruby ruby_version ruby_dependencies
}

SHUNIT_PARENT=$0 . $SHUNIT2
