#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/package_manager.sh

function setUp()
{
	detect_package_manager
}

function test_detect_package_manager_with_apt_get()
{
	command -v apt-get >/dev/null || return

	assertEquals "did not detect apt-get" "apt" "$package_manager" 
}

function test_detect_package_manager_with_dnf()
{
	command -v dnf >/dev/null || return

	assertEquals "did not detect dnf" "dnf" "$package_manager"
}

function test_detect_package_manager_with_yum()
{
	command -v dnf >/dev/null && return
	command -v yum >/dev/null || return

	assertEquals "did not detect yum" "yum" "$package_manager" 
}

function test_detect_package_manager_with_zypper()
{
	command -v zypper >/dev/null || return

	assertEquals "did not detect zypper" "zypper" "$package_manager" 
}

function test_detect_package_manager_with_pkg()
{
	command -v pkg >/dev/null || return

	assertEquals "did not detect pkg" "pkg" "$package_manager"
}

function test_detect_package_manager_with_macports()
{
	command -v port >/dev/null || return

	assertEquals "did not detect macports" "port" "$package_manager" 
}

function test_detect_package_manager_with_homebrew()
{
	command -v brew >/dev/null || return

	assertEquals "did not detect homebrew" "brew" "$package_manager" 
}

SHUNIT_PARENT=$0 . $SHUNIT2
