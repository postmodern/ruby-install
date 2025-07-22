#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/functions.sh

function setUp()
{
	ruby="ruby"
	ruby_version="3.4.0"
	package_manager="dnf"
}

function test_load_dependencies()
{
	load_dependencies

	assertEquals "did not correctly set \$ruby_dependencies from \$ruby/dependencies.sh for \$package_manager" \
		     "xz gcc automake zlib-devel libyaml-devel openssl-devel ncurses-devel libffi-devel" \
		     "${ruby_dependencies[*]}"
}

function tearDown()
{
	unset ruby ruby_version package_manager
}

SHUNIT_PARENT=$0 . $SHUNIT2
