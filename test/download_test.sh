. ./test/helper.sh

URL="https://raw.github.com/postmodern/ruby-install/master/README.md"
OUTPUT="./test/download.txt"

test_download()
{
	download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

test_download_using_wget()
{
	[[ ! $(type -t wget) ]] && return

	DOWNLOADER="wget" download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

test_download_using_curl()
{
	[[ ! $(type -t curl ) ]] && return

	DOWNLOADER="curl" download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

tearDown()
{
	rm "$OUTPUT"
}

SHUNIT_PARENT=$0 . $SHUNIT2
