. ./test/helper.sh

function setUp()
{
	RUBY="ruby"
	RUBY_VERSION="1.8"
	EXPANDED_RUBY_VERSION="1.8.7-p374"
}

function test_load_ruby()
{
	load_ruby

	assertEquals "did not return 0" 0 $?
}

function test_load_ruby_with_invalid_RUBY()
{
	RUBY="foo"

	load_ruby 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_RUBY_VERSION()
{
	load_ruby

	assertEquals "did not expand RUBY_VERSION" \
		     "$EXPANDED_RUBY_VERSION" \
		     "$RUBY_VERSION"
}

function test_load_ruby_with_RUBY_URL()
{
	local url="http://mirror.s3.amazonaws.com/downloads/ruby-1.2.3.tar.gz"

	RUBY_URL="$url"
	load_ruby

	assertEquals "did not preserve RUBY_URL" "$url" "$RUBY_URL"
}

function test_load_ruby_RUBY_MD5()
{
	load_ruby

	assertNotNull "did not set RUBY_MD5" $RUBY_MD5
}

function test_load_ruby_with_RUBY_MD5()
{
	local md5="b1946ac92492d2347c6235b4d2611184"

	RUBY_MD5="$md5"
	load_ruby

	assertEquals "did not preserve RUBY_MD5" "$md5" "$RUBY_MD5"
}

function test_SRC_DIR()
{
	load_ruby

	if (( $UID == 0 )); then
		assertEquals "did not correctly default SRC_DIR" \
			     "/usr/local/src" \
			     "$SRC_DIR"
	else
		assertEquals "did not correctly default SRC_DIR" \
			     "$HOME/src" \
			     "$SRC_DIR"
	fi
}

function test_INSTALL_DIR()
{
	load_ruby

	if (( $UID == 0 )); then
		assertEquals "did not correctly default INSTALL_DIR" \
			     "/opt/rubies/$RUBY-$EXPANDED_RUBY_VERSION" \
			     "$INSTALL_DIR"
	else
		assertEquals "did not correctly default INSTALL_DIR" \
			     "$HOME/.rubies/$RUBY-$EXPANDED_RUBY_VERSION" \
			     "$INSTALL_DIR"
	fi
}

function tearDown()
{
	unset SRC_DIR INSTALL_DIR
	unset RUBY RUBY_VERSION RUBY_MD5 RUBY_ARCHIVE RUBY_SRC_DIR RUBY_URL
}

SHUNIT_PARENT=$0 . $SHUNIT2
