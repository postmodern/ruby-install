. ./test/helper.sh

PATCHES=("https://raw.github.com/gist/4136373/falcon-gc.diff" "local.patch")

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
		   '[[ -f "$SRC_DIR/$RUBY_SRC_DIR/falcon-gc.diff" ]]'
}

function tearDown()
{
	rm -r "$SRC_DIR/$RUBY_SRC_DIR"
}

SHUNIT_PARENT=$0 . $SHUNIT2
