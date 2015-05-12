#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	unset ruby
	unset ruby_dir
	unset ruby_cache_dir
}

function test_parse_ruby()
{
	local expected_ruby="jruby"
	local expected_ruby_dir="$ruby_install_dir/$expected_ruby"
	local expected_ruby_cache_dir="$cache_dir/$expected_ruby"

	parse_ruby "$expected_ruby"

	assertEquals "did not return successfully" 0 $?
	assertEquals "did not set \$ruby" "$expected_ruby" "$ruby"
	assertEquals "did not set \$ruby_dir" "$expected_ruby_dir" "$ruby_dir"
	assertEquals "did not set \$ruby_cache_dir" "$expected_ruby_cache_dir" \
						    "$ruby_cache_dir"
}

function test_parse_ruby_with_invalid_ruby()
{
	parse_ruby "foo" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
