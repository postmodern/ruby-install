. ./test/helper.sh

function setUp()
{
	unset RUBY
	unset RUBY_VERSION
	unset SRC_DIR
	unset INSTALL_DIR
}

function test_parse_options_with_no_arguments()
{
	parse_options >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

function test_parse_options_with_invalid_options()
{
	parse_options "--foo" "ruby" >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

function test_parse_options_with_one_argument()
{
	local expected="jruby"

	parse_options $expected

	assertEquals "did not set \$RUBY" $expected $RUBY
}

function test_parse_options_with_two_arguments()
{
	local expected_ruby="jruby"
	local expected_version="1.7.4"

	parse_options $expected_ruby $expected_version

	assertEquals "did not set \$RUBY" $expected_ruby $RUBY
	assertEquals "did not set \$RUBY_VERSION" $expected_version \
		     				  $RUBY_VERSION
}

function test_parse_options_with_more_than_two_arguments()
{
	parse_options "jruby" "1.7.4" "foo" >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

function test_parse_options_with_install_dir()
{
	local expected="/usr/local/"

	parse_options "--install-dir" $expected "ruby"

	assertEquals "did not set \$INSTALL_DIR" $expected $INSTALL_DIR
}

function test_parse_options_with_src_dir()
{
	local expected="~/src/"

	parse_options "--src-dir" $expected "ruby"

	assertEquals "did not set \$SRC_DIR" $expected $SRC_DIR
}

function test_parse_options_with_patches()
{
	local expected=(patch1.diff patch2.diff)

	parse_options "--patch" ${expected[0]} "--patch" ${expected[1]} "ruby"

	assertEquals "did not set \$PATCHES" $expected $PATCHES
}

function test_parse_options_with_mirror()
{
	local mirror="http://www.mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby"

	parse_options "--mirror" "$mirror" "ruby"

	assertEquals "did not set \$RUBY_MIRROR" "$mirror" "$RUBY_MIRROR"
}

function test_parse_options_with_url()
{
	local url="http://mirror.s3.amazonaws.com/downloads/ruby-1.2.3.tar.gz"

	parse_options "--url" "$url" "ruby"

	assertEquals "did not set \$RUBY_URL" "$url" "$RUBY_URL"
}

function test_parse_options_with_md5()
{
	local md5="5d41402abc4b2a76b9719d911017c592"

	parse_options "--md5" "$md5" "ruby"

	assertEquals "did not set \$RUBY_MD5" "$md5" "$RUBY_MD5"
}

function test_parse_options_with_no_download()
{
	parse_options "--no-download" "ruby"

 	assertEquals "did not set \$NO_DOWNLOAD" 1 $NO_DOWNLOAD
}

function test_parse_options_with_no_verify()
{
	parse_options "--no-verify" "ruby"

 	assertEquals "did not set \$NO_VERIFY" 1 $NO_VERIFY
}

function test_parse_options_with_no_install_deps()
{
	parse_options "--no-install-deps" "ruby"

 	assertEquals "did not set \$NO_INSTALL_DEPS" 1 $NO_INSTALL_DEPS
}

function test_parse_options_with_no_reinstall()
{
	parse_options "--no-reinstall" "ruby"

	assertEquals "did not set to \$NO_REINSTALL" 1 $NO_REINSTALL
}

function test_parse_options_with_additional_options()
{
	local expected=(--enable-shared CFLAGS="-03")

	parse_options "ruby" "--" $expected

	assertEquals "did not set \$CONFIGURE_OPTS" $expected $CONFIGURE_OPTS
}

SHUNIT_PARENT=$0 . $SHUNIT2
