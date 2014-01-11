. ./test/helper.sh

PATCHES=("https://gist.github.com/funny-falcon/2981959/raw/ary-queue.diff" "local.patch")

function setUp()
{
	SRC_DIR="$PWD/test/src"
	RUBY_SRC_DIR="ruby-1.9.3-p448"

	mkdir -p "$SRC_DIR/$RUBY_SRC_DIR"
}

function test_download_patches()
{
	download_patches 2>/dev/null

	assertTrue "did not download patches to the directory" \
		   '[[ -f "$SRC_DIR/$RUBY_SRC_DIR/ary-queue.diff" ]]'
}

function tearDown()
{
	rm -r "$SRC_DIR/$RUBY_SRC_DIR"
}

SHUNIT_PARENT=$0 . $SHUNIT2
