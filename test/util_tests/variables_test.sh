#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/util.sh

function test_package_manager_with_apt_get()
{
	command -v apt-get >/dev/null || return

	assertEquals "did not detect apt-get" "apt" "$package_manager" 
}

function test_package_manager_with_dnf()
{
	command -v dnf >/dev/null || return

	assertEquals "did not detect dnf" "dnf" "$package_manager"
}

function test_package_manager_with_yum()
{
	command -v dnf >/dev/null && return
	command -v yum >/dev/null || return

	assertEquals "did not detect yum" "yum" "$package_manager" 
}

function test_package_manager_with_macports()
{
	command -v port >/dev/null || return

	assertEquals "did not detect macports" "port" "$package_manager" 
}

function test_package_manager_with_homebrew()
{
	command -v brew >/dev/null || return

	assertEquals "did not detect homebrew" "brew" "$package_manager" 
}

function test_downloader_with_wget()
{
	command -v wget >/dev/null || return

	assertEquals "did not detect wget" "wget" "$downloader" 
}

function test_downloader_without_wget_but_with_curl()
{
	(! command -v wget >/dev/null && command -v curl >/dev/null) || return

	assertEquals "did not detect curl" "curl" "$downloader" 
}

function test_sudo()
{
	if (( UID == 0 )); then
		assertEquals "did not omit sudo" "" "$sudo"
	else
		assertEquals "did not enable sudo" "sudo" "$sudo"
	fi
}

SHUNIT_PARENT=$0 . $SHUNIT2
