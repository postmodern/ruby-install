#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/functions.sh

src_dir="$test_fixtures_dir/apply_patches_test"
ruby_and_version="ruby-1.9.3-p448"
ruby_build_dir="$src_dir/$ruby_and_version"

patches=("$ruby_build_dir/falcon-gc.diff")

function setUp()
{
	mkdir -p "$ruby_build_dir"
	echo "diff -Naur $ruby_and_version.orig/test $ruby_and_version/test
--- $ruby_and_version.orig/test 1970-01-01 01:00:00.000000000 +0100
+++ $ruby_and_version/test  2013-08-02 20:57:08.055843749 +0200
@@ -0,0 +1 @@
+patch
" > "${patches[0]}"
}

function test_apply_patches()
{
	cd "$ruby_build_dir"
	apply_patches >/dev/null
	cd $OLDPWD

	assertTrue "did not apply downloaded patches" \
		   '[[ -f "${ruby_build_dir}/test" ]]'
}

function tearDown()
{
	rm -rf "$src_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
