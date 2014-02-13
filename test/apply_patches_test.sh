. ./test/helper.sh

function setUp()
{
	src_dir="$PWD/test/src"
	ruby_src_dir="ruby-1.9.3-p448"
	patches=("$src_dir/$ruby_src_dir/falcon-gc.diff")

	mkdir -p "$src_dir/$ruby_src_dir"
	echo "diff -Naur $ruby_src_dir.orig/test $ruby_src_dir/test
--- $ruby_src_dir.orig/test 1970-01-01 01:00:00.000000000 +0100
+++ $ruby_src_dir/test  2013-08-02 20:57:08.055843749 +0200
@@ -0,0 +1 @@
+patch
" > "${patches[0]}"
}

function test_apply_patches()
{
	cd "$src_dir/$ruby_src_dir"
	apply_patches >/dev/null
	cd $OLDPWD

	assertTrue "did not apply downloaded patches" \
		   '[[ -f "$src_dir/$ruby_src_dir/test" ]]'
}

function tearDown()
{
	rm -r "$src_dir/$ruby_src_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
