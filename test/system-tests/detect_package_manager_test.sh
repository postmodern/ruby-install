#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/system.sh

function oneTimeSetUp()
{
	detect_package_manager
}

function test_detect_package_manager_on_redhat_based_systems_with_dnf()
{
	[[ -f /etc/redhat-release ]] && command -v dnf >/dev/null || return 0

	assertEquals "did not prefer dnf over yum" "dnf" "$package_manager"
}

function test_detect_package_manager_on_redhat_based_systems_with_yum()
{
	[[ -f /etc/redhat-release ]] &&
		! command -v dnf >/dev/null &&
		command -v yum >/dev/null || return 0

	assertEquals "did not fallback to yum" "yum" "$package_manager"
}

function test_detect_package_manager_on_debian_based_systems_with_apt()
{
	[[ -f /etc/debian_version ]] && command -v apt >/dev/null || \
		return 0

	assertEquals "did not detect apt" "apt" "$package_manager"
}

function test_detect_package_manager_on_open_suse_systems_with_zypper()
{
	[[ -f /etc/SuSE-release ]] && command -v zypper >/dev/null || return 0

	assertEquals "did not detect zypper" "zypper" "$package_manager"
}

function test_detect_package_manager_on_bsd_systems_with_pkg()
{
	[[ "$os_platform" == *BSD ]] && command -v pkg >/dev/null || return 0

	assertEquals "did not detect pkg" "pkg" "$package_manager"
}

function test_detect_package_manager_on_macos_systems_with_homebrew()
{
	[[ "$os_platform" == *Darwin ]] && command -v brew >/dev/null || \
		return 0

	assertEquals "did not prefer brew over port" "brew" "$package_manager"
}

function test_detect_package_manager_on_macos_systems_with_macports()
{
	[[ "$os_platform" == *Darwin ]] &&
		! command -v brew >/dev/null &&
		command -v port >/dev/null || return 0

	assertEquals "did not fallback to macports" "port" "$package_manager"
}

SHUNIT_PARENT=$0 . $SHUNIT2
