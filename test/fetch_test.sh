. ./test/helper.sh

RUBY_INSTALL_DIR="./test/dir"

function setUp()
{
	RUBY=ruby
	TAB=$'\t'

	mkdir -p "$RUBY_INSTALL_DIR/$RUBY"
	echo "1.8.7:${TAB}${TAB}1.8.7-p374" > "$RUBY_INSTALL_DIR/$RUBY/versions.txt"
	echo "ruby-1.8.7-p374.tar.bz2: 83c92e2b57ea08f31187060098b2200b" > "$RUBY_INSTALL_DIR/$RUBY/md5.txt"
}

function test_fetch()
{
	local key="1.8.7"
	local expected="1.8.7-p374"
	local value=$(fetch "$RUBY/versions" "$key")

	assertEquals "did not fetch the correct value" "$expected" "$value"
}

function test_fetch_with_excess_whitespace()
{
	local key="ruby-1.8.7-p374.tar.bz2"
	local expected="83c92e2b57ea08f31187060098b2200b"
	local value=$(fetch "$RUBY/md5" "$key")

	assertEquals "did not fetch the correct value" "$expected" "$value"
}

function test_fetch_with_unknown_key()
{
	local key="foo"
	local expected=""
	local value=$(fetch "$RUBY/versions" "$key")

	assertEquals "returned the wrong value" "$expected" "$value"
}

function tearDown()
{
	rm -r "$RUBY_INSTALL_DIR"
}

SHUNIT_PARENT=$0 . $SHUNIT2
