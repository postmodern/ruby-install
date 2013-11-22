. ./test/helper.sh

RUBY_INSTALL_DIR="./test/tmp"
FILE="$RUBY_INSTALL_DIR/db.txt"

function setUp()
{
	mkdir "$RUBY_INSTALL_DIR"
}

function test_fetch()
{
	local key="1.8.7"
	local expected="1.8.7-p374"

	echo "$key: $expected" > "$FILE"

	local value=$(fetch "db" "$key")

	assertEquals "did not fetch the correct value" "$expected" "$value"
}

function test_fetch_with_tabs()
{
	local key="ruby-1.8.7-p374.tar.bz2"
	local expected="83c92e2b57ea08f31187060098b2200b"

	echo -e "$key:\t$expected" > "$FILE"

	local value=$(fetch "db" "$key")

	assertEquals "did not remove the trailing tabs" "$expected" "$value"
}

function test_fetch_with_excess_whitespace()
{
	local key="ruby-1.8.7-p374.tar.bz2"
	local expected="83c92e2b57ea08f31187060098b2200b"

	echo "$key:     $expected" > "$FILE"

	local value=$(fetch "db" "$key")

	assertEquals "did not fetch the correct value" "$expected" "$value"
}

function test_fetch_with_unknown_key()
{
	local key="foo"
	local expected=""

	echo "bar: bar" > "$FILE"

	local value=$(fetch "db" "$key")

	assertEquals "returned the wrong value" "$expected" "$value"
}

function tearDown()
{
	rm -r "$RUBY_INSTALL_DIR"
}

SHUNIT_PARENT=$0 . $SHUNIT2
