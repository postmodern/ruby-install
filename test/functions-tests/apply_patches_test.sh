#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/functions.sh

src_dir="$test_fixtures_dir/apply_patches_test"
ruby_dir_name="ruby-1.9.3-p448"
patches=("$src_dir/$ruby_dir_name/falcon-gc.diff")

function setUp()
{
	mkdir -p "$src_dir/$ruby_dir_name"
	echo "diff -Naur $ruby_dir_name.orig/test $ruby_dir_name/test
--- $ruby_dir_name.orig/test 1970-01-01 01:00:00.000000000 +0100
+++ $ruby_dir_name/test  2013-08-02 20:57:08.055843749 +0200
@@ -0,0 +1 @@
+patch
" > "${patches[0]}"
}

function test_apply_patches()
{
	cd "$src_dir/$ruby_dir_name"
	apply_patches >/dev/null
	cd $OLDPWD

	assertTrue "did not apply downloaded patches" \
		   '[[ -f "$src_dir/$ruby_dir_name/test" ]]'
}

function tearDown()
{
	rm -rf "$src_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
