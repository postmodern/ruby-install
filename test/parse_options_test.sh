. ./test/helper.sh

test_parse_options_with_no_arguments()
{
	parse_options >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

test_parse_options_with_invalid_options()
{
	parse_options "--foo" "ruby"

	assertEquals "did not return 1" 1 $?
}

test_parse_options_with_one_argument()
{
	local expected="jruby"

	parse_options $expected

	assertEquals "did not set \$RUBY" $expected $RUBY
}

test_parse_options_with_two_arguments()
{
	local expected_ruby="jruby"
	local expected_version="1.7.4"

	parse_options $expected_ruby $expected_version

	assertEquals "did not set \$RUBY" $expected_ruby $RUBY
	assertEquals "did not set \$RUBY_VERSION" $expected_version \
		     				  $RUBY_VERSION
}

test_parse_options_with_more_than_two_arguments()
{
	parse_options "jruby" "1.7.4" "foo" >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

test_parse_options_with_install_dir()
{
	local expected="/usr/local/"

	parse_options "--install-dir" $expected "ruby"

	assertEquals "did not set \$INSTALL_DIR" $expected $INSTALL_DIR
}

test_parse_options_with_src_dir()
{
	local expected="~/src/"

	parse_options "--src-dir" $expected "ruby"

	assertEquals "did not set \$SRC_DIR" $expected $SRC_DIR
}

test_parse_options_with_patches()
{
	local expected=(patch1.diff patch2.diff)

	parse_options "--patch" ${expected[0]} "--patch" ${expected[1]} "ruby"

	assertEquals "did not set \$PATCHES" $expected $PATCHES
}

test_parse_options_with_additional_options()
{
	local expected=(--enable-shared CFLAGS="-03")

	parse_options "ruby" "--" $expected

	assertEquals "did not set \$CONFIGURE_OPTS" $expected $CONFIGURE_OPTS
}

SHUNIT_PARENT=$0 . $SHUNIT2
