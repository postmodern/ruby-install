#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/util.sh

function test_check_write_permissions_with_non_existent_directory_within_a_writable_parent_directory()
{
	local path="/tmp/foo/bar"

	assertTrue "did not return true" 'check_write_permissions "$path"'
}

function test_check_write_permissions_with_non_existent_directory_within_a_non_writable_parent_directory()
{
	local path="/root/foo/bar"

	assertFalse "did not return false" 'check_write_permissions "$path"'
}

function test_check_write_permissions_with_an_existing_directory_that_is_writable()
{
	local path="$PWD"

	assertTrue "did not return true" 'check_write_permissions "$path"'
}

function test_check_write_permissions_with_an_existing_directory_that_is_not_writable()
{
	local path="/root"

	assertFalse "did not return true" 'check_write_permissions "$path"'
}

SHUNIT_PARENT=$0 . $SHUNIT2
