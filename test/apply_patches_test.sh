. ./test/helper.sh

PATCHES=("https://raw.github.com/gist/4136373/falcon-gc.diff")

function setUp()
{
	SRC_DIR="$PWD/test/src"
	RUBY_SRC_DIR="ruby-1.9.3-p448"

	mkdir -p "$SRC_DIR/$RUBY_SRC_DIR"
}

function test_apply_patches()
{
	echo "
diff -Naur $RUBY_SRC_DIR.orig/test $RUBY_SRC_DIR/test
--- $RUBY_SRC_DIR.orig/test 1970-01-01 01:00:00.000000000 +0100
+++ $RUBY_SRC_DIR/test  2013-08-02 20:57:08.055843749 +0200
@@ -0,0 +1 @@
+patch
" 	> "$SRC_DIR/$RUBY_SRC_DIR/falcon-gc.diff"

	cd "$SRC_DIR/$RUBY_SRC_DIR"
	apply_patches >/dev/null
	cd $OLDPWD

	assertTrue "did not apply downloaded patches" \
		   '[[ -f "$SRC_DIR/$RUBY_SRC_DIR/test" ]]'
}

function tearDown()
{
	rm -r "$SRC_DIR/$RUBY_SRC_DIR"
}

SHUNIT_PARENT=$0 . $SHUNIT2
