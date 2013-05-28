. ./test/helper.sh

test_load_ruby()
{
	RUBY="ruby"
	RUBY_VERSION="stable"

	load_ruby

	assertEquals "did not return 0" 0 $?
}

test_load_ruby_with_invalid_RUBY()
{
	RUBY="foo"

	load_ruby 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
