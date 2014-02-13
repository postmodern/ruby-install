. ./test/helper.sh

install_dir="./test/dir"

function setUp()
{
	mkdir -p "$install_dir/bin"
	touch -m "$install_dir/bin/ruby"
	chmod +x "$install_dir/bin/ruby"
}

function test_no_reinstall_when_ruby_executable_exists()
{
	local output="$(ruby-install --install-dir "$install_dir" --no-reinstall ruby)"

	assertEquals "did not return 0" 0 $?
	assertTrue "did not print a message to STDOUT" \
		'[[ "$output" == *"already installed"* ]]'
}

function tearDown()
{
	rm -r "$install_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
