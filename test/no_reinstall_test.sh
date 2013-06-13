. ./test/helper.sh

setUp()
{
	INSTALL_DIR=`mktemp -d /tmp/ruby-install.XXXX`
	SRC_DIR=`mktemp -d /tmp/ruby-src.XXXX`
	RUBY="ruby"
	RUBY_VERSION="1.9.3-p429"

	local fake_ruby="$INSTALL_DIR/bin/ruby"

	mkdir "$(dirname $fake_ruby)"

	# Let's pretend there's a working ruby interpreter in the fake installation
	# directory and let it stub the version information
	echo <<EOF > "$fake_ruby"
#!/usr/bin/env bash
exit 0
EOF
	chmod +x "$fake_ruby"
}

test_skip_reinstall_existing_ruby()
{
	NO_REINSTALL=1 
	check_reinstall >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

test_skip_reinstall_when_nonexisting_ruby()
{
	rm -rf $INSTALL_DIR >/dev/null 2>&1
	INSTALL_DIR="/tmp/foo/bar/baz"

	NO_REINSTALL=1
	check_reinstall >/dev/null 2>&1

	assertEquals "did not return 0" 0 $?
}

test_do_not_skip_reinstall()
{
	unset NO_REINSTALL
	check_reinstall >/dev/null 2>&1

	assertEquals "did not return 0" 0 $?
}

tearDown()
{
	rm -rf $INSTALL_DIR >/dev/null 2>&1
	rmdir $SRC_DIR
}

SHUNIT_PARENT=$0 . $SHUNIT2
