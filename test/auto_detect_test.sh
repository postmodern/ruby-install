. ./test/helper.sh

setUp()
{
	auto_detect
}

test_auto_detect()
{
	assertNotNull "did not set \$MD5SUM" $MD5SUM
	assertEquals "did not define download()" "function" $(type -t download)
	assertNotNull "did not set \$PACKAGE_MANAGER" $PACKAGE_MANAGER
}

test_auto_detect_md5()
{
	local data="hello world"
	local md5="6f5902ac237024bdd0c176cb93063dc4"
	local path="./test/file.txt"

	echo "$data" > $path
	local output=$($MD5SUM "$path")

	assertTrue "did not return the correct MD5" '[[ $output == *$md5* ]]'

	rm "$path"
}

test_auto_detect_download()
{
	local url="https://raw.github.com/postmodern/ruby-install/master/README.md"
	local output="./test/download.txt"

	download "$url" "$output" 2>/dev/null

	assertTrue "did not download the file" '[[ -f $output ]]'

	rm "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
