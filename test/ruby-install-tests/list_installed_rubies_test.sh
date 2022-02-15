#!/usr/bin/env bash

. ./test/helper.sh

function test_list_installed_rubies()
{
	mkdir -p "$HOME/.rubies/ruby-2.7.5"
	mkdir -p "$HOME/.rubies/ruby-3.1.0"

	local output="$(list_installed_rubies)"

	assertTrue "did include ruby-2.7.5" '[[ "$output" == *ruby-2.7.5* ]]'
	assertTrue "did include ruby-3.1.0" '[[ "$output" == *ruby-3.1.0* ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
