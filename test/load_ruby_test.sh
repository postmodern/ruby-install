. ./test/helper.sh

setUp()
{
	RUBY="ruby"
	RUBY_VERSION="1.8"
	EXPANDED_RUBY_VERSION="1.8.7-p371"
}

test_load_ruby()
{
	load_ruby

	assertEquals "did not return 0" 0 $?
}

test_load_ruby_with_invalid_RUBY()
{
	RUBY="foo"

	load_ruby 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

test_RUBY_VERSION()
{
	load_ruby

	assertEquals "did not expand RUBY_VERSION" \
		     "$EXPANDED_RUBY_VERSION" \
		     "$RUBY_VERSION"
}

test_SRC_DIR()
{
	load_ruby

	if [[ $UID -eq 0 ]]; then
		assertEquals "did not correctly default SRC_DIR" \
			     "/usr/local/src" \
			     "$SRC_DIR"
	else
		assertEquals "did not correctly default SRC_DIR" \
			     "$HOME/src" \
			     "$SRC_DIR"
	fi
}

test_INSTALL_DIR()
{
	load_ruby

	if [[ $UID -eq 0 ]]; then
		assertEquals "did not correctly default INSTALL_DIR" \
			     "/opt/rubies/$RUBY-$EXPANDED_RUBY_VERSION" \
			     "$INSTALL_DIR"
	else
		assertEquals "did not correctly default INSTALL_DIR" \
			     "$HOME/.rubies/$RUBY-$EXPANDED_RUBY_VERSION" \
			     "$INSTALL_DIR"
	fi
}

tearDown()
{
	unset RUBY RUBY_VERSION RUBY_ARCHIVE RUBY_SRC_DIR SRC_DIR INSTALL_DIR
}

SHUNIT_PARENT=$0 . $SHUNIT2
