#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/functions.sh

src_dir="$test_fixtures_dir/download_patches_test"

patches=("https://gist.github.com/funny-falcon/2981959/raw/ary-queue.diff" "local.patch")
ruby_dir_name="ruby-1.9.3-p448"

function setUp()
{
	mkdir -p "$src_dir/$ruby_dir_name"
}

function test_download_patches()
{
	download_patches 2>/dev/null

	assertTrue "did not download patches to \$src_dir/\$ruby_dir_name" \
		   '[[ -f "$src_dir/$ruby_dir_name/ary-queue.diff" ]]'

	assertEquals "did not update \$patches" \
		     "${patches[0]}" "$src_dir/$ruby_dir_name/ary-queue.diff"

	ls "$src_dir/$ruby_dir_name"
}

function tearDown()
{
	rm -rf "$src_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
