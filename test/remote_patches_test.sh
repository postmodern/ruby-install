. ./test/helper.sh

PATCHES="https://raw.github.com/gist/4136373/falcon-gc.diff local.patch"

test_download_patches()
{
	local dir="test/subdir"
	local SRC_DIR=$dir

	mkdir -p "$dir"

	download_patches 2>/dev/null

	assertTrue "did not download patches to the directory" \
		'[[ -f "$dir/falcon-gc.diff" ]]'

	rm -r "$dir"
}

test_apply_patches()
{
	local dir="test/subdir"
	local SRC_DIR=$dir

	mkdir -p "$dir"
	echo "
diff -Naur subdir.orig/test subdir/test
--- subdir.orig/test 1970-01-01 01:00:00.000000000 +0100
+++ subdir/test  2013-08-02 20:57:08.055843749 +0200
@@ -0,0 +1 @@
+patch
" 	> "$dir/falcon-gc.diff"

	apply_patches 2>/dev/null

	assertTrue "did not apply downloaded patches" \
		'[[ -f "$dir/test" ]]'

	rm -r "$dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
