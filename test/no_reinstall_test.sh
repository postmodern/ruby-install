. ./test/helper.sh

INSTALL_DIR="./test/dir"

function setUp()
{
	mkdir -p "$INSTALL_DIR/bin"
	touch -m "$INSTALL_DIR/bin/ruby"
	chmod +x "$INSTALL_DIR/bin/ruby"
}

function test_no_reinstall_when_ruby_executable_exists()
{
	local output="$(ruby-install --install-dir "$INSTALL_DIR" --no-reinstall ruby)"

	assertEquals "did not return 0" 0 $?
	assertTrue "did not print a message to STDOUT" \
		'[[ "$output" == *"already installed"* ]]'
}

function tearDown()
{
	rm -r "$INSTALL_DIR"
}

SHUNIT_PARENT=$0 . $SHUNIT2
