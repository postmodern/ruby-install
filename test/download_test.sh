. ./test/helper.sh

test_download()
{
	local url="https://raw.github.com/postmodern/ruby-install/master/README.md"
	local output="./test/download.txt"

	download "$url" "$output" 2>/dev/null

	assertTrue "did not download the file" '[[ -f $output ]]'

	rm "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
