. ./test/helper.sh

function setUp()
{
	ruby="ruby"
	ruby_version="1.9"
	expanded_ruby_version="1.9.3-p545"
}

function test_load_ruby()
{
	load_ruby

	assertEquals "did not return 0" 0 $?
}

function test_load_ruby_with_invalid_ruby()
{
	ruby="foo"

	load_ruby 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_ruby_version()
{
	load_ruby

	assertEquals "did not expand ruby_version" \
		     "$expanded_ruby_version" \
		     "$ruby_version"
}

function test_load_ruby_with_ruby_url()
{
	local url="http://mirror.s3.amazonaws.com/downloads/ruby-1.2.3.tar.gz"

	ruby_url="$url"
	load_ruby

	assertEquals "did not preserve ruby_url" "$url" "$ruby_url"
}

function test_load_ruby_ruby_md5()
{
	load_ruby

	assertNotNull "did not set ruby_md5" $ruby_md5
}

function test_load_ruby_with_ruby_md5()
{
	local md5="b1946ac92492d2347c6235b4d2611184"

	ruby_md5="$md5"
	load_ruby

	assertEquals "did not preserve ruby_md5" "$md5" "$ruby_md5"
}

function test_src_dir()
{
	load_ruby

	if (( $UID == 0 )); then
		assertEquals "did not correctly default src_dir" \
			     "/usr/local/src" \
			     "$src_dir"
	else
		assertEquals "did not correctly default src_dir" \
			     "$HOME/src" \
			     "$src_dir"
	fi
}

function test_rubies_dir()
{
	load_ruby

	if (( $UID == 0 )); then
		assertEquals "did not correctly default rubies_dir" \
			     "/opt/rubies" \
			     "$rubies_dir"
	else
		assertEquals "did not correctly default rubies_dir" \
			     "$HOME/.rubies" \
			     "$rubies_dir"
	fi
}

function test_install_dir()
{
	load_ruby

	if (( $UID == 0 )); then
		assertEquals "did not correctly default install_dir" \
			     "$rubies_dir/$ruby-$expanded_ruby_version" \
			     "$install_dir"
	else
		assertEquals "did not correctly default install_dir" \
			     "$rubies_dir/$ruby-$expanded_ruby_version" \
			     "$install_dir"
	fi
}

function tearDown()
{
	unset src_dir rubies_dir install_dir
	unset ruby ruby_version ruby_md5 ruby_archive ruby_src_dir ruby_url
}

SHUNIT_PARENT=$0 . $SHUNIT2
