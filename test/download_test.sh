. ./test/helper.sh

URL="https://raw.github.com/postmodern/ruby-install/master/README.md"
OUTPUT="./test/download.txt"

function test_download()
{
	download "$URL" "$OUTPUT" 2>/dev/null

	assertFalse "did not remove the .part file" '[[ -f "$OUTPUT.part" ]]'
	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

function test_download_with_a_directory()
{
	local dir="test/subdir"
	mkdir -p "$dir"

	download "$URL" "$dir" 2>/dev/null

	assertTrue "did not download the file to the directory" \
	           '[[ -f "$dir/README.md" ]]'

	rm -r "$dir"
}

function test_download_using_wget()
{
	command -v wget >/dev/null || return

	downloader="wget" download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

function test_download_using_curl()
{
	command -v curl >/dev/null || return

	downloader="curl" download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

function tearDown()
{
	rm -f "$OUTPUT"
}

SHUNIT_PARENT=$0 . $SHUNIT2
