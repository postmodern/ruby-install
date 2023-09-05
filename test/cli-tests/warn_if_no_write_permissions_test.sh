#!/usr/bin/env bash

. ./test/helper.sh

test_install_dir="$test_fixtures_dir/no_write_permissions_test"

function setUp()
{
	mkdir -p "$test_install_dir/bin"
	chmod -w "$test_install_dir/bin"
}

function test_no_write_permissions()
{
	local output status
	output="$(ruby-install --install-dir "$test_install_dir/bin/rubies" ruby 2>&1)"
	status=$?

	assertEquals "did not return 0" 255 $status
	assertTrue "did not print a message to STDOUT" \
		'[[ "$output" == *"Installation directory is not writable by the user"* ]]'
}

function tearDown()
{
	rm -rf "$test_install_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
