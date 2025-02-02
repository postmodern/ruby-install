#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/util.sh

function test_absolute_path_with_relative_path()
{
	local path="foo/bar"
	local expected="${PWD}/${path}"

	assertEquals "did not return the correct absolute path" \
		     "$expected" "$(absolute_path "$path")"
}

function test_absolute_path_with_absolute_path()
{
	local path="/foo/bar"

	assertEquals "did not return the the absolute path" \
		     "$path" "$(absolute_path "$path")"
}

SHUNIT_PARENT=$0 . $SHUNIT2
