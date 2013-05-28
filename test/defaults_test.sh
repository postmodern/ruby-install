. ./test/helper.sh

RUBY="ruby"
RUBY_VERSION="1.8"
EXPANDED_RUBY_VERSION="1.8.7-p371"

setUp()
{
	defaults
}

test_RUBY_VERSION()
{
	assertEquals "did not expand RUBY_VERSION" \
		     "$EXPANDED_RUBY_VERSION" \
		     "$RUBY_VERSION"
}

test_RUBY_ARCHIVE()
{
	assertEquals "did not set RUBY_ARCHIVE" \
		     "$RUBY-$EXPANDED_RUBY_VERSION.tar.gz" \
		     "$RUBY_ARCHIVE"
}

test_RUBY_SRC_DIR()
{
	assertEquals "did not set RUBY_SRC_DIR" \
		     "$RUBY-$EXPANDED_RUBY_VERSION" \
		     "$RUBY_SRC_DIR"
}

test_SRC_DIR()
{
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
	if [[ $UID -eq 0 ]]; then
		assertEquals "did not correctly default INSTALL_DIR" \
			     "/opt/rubies/$RUBY-$EXPANDED_RUBY_VERSION" \
			     "$INSTALL_DIR"
	else
		assertEquals "did not correctly default SRC_DIR" \
			     "$HOME/.rubies/$RUBY-$EXPANDED_RUBY_VERSION" \
			     "$INSTALL_DIR"
	fi
}

SHUNIT_PARENT=$0 . $SHUNIT2
