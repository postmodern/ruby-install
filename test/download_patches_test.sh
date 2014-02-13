. ./test/helper.sh

patches=("https://gist.github.com/funny-falcon/2981959/raw/ary-queue.diff" "local.patch")

function setUp()
{
	src_dir="$PWD/test/src"
	ruby_src_dir="ruby-1.9.3-p448"

	mkdir -p "$src_dir/$ruby_src_dir"
}

function test_download_patches()
{
	download_patches 2>/dev/null

	assertTrue "did not download patches to \$src_dir/\$ruby_src_dir" \
		   '[[ -f "$src_dir/$ruby_src_dir/ary-queue.diff" ]]'
	assertEquals "did not update \$patches" \
		     "${patches[0]}" "$src_dir/$ruby_src_dir/ary-queue.diff" 
}

function tearDown()
{
	rm -r "$src_dir/$ruby_src_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
