#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	unset ruby
	unset ruby_cache_dir
}

function test_parse_ruby_with_a_single_name()
{
	local expected_ruby="jruby"

	parse_ruby "$expected_ruby"

	assertEquals "did not return successfully" 0 $?
	assertEquals "did not set \$ruby" "$expected_ruby" "$ruby"
}

function test_parse_ruby_with_a_name_and_version()
{
	local expected_ruby="jruby"
	local expected_version="9.0.0"

	parse_ruby "${expected_ruby}-${expected_version}"

	assertEquals "did not return successfully" 0 $?
	assertEquals "did not set \$ruby" "$ruby" "$expected_ruby"
	assertEquals "did not set \$ruby_version" "$expected_version" \
						  "$ruby_version"
}

function test_parse_ruby_with_invalid_ruby()
{
	parse_ruby "foo" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
