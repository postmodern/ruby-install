#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/util.sh

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
