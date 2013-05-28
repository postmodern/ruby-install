. ./test/helper.sh

test_verify()
{
	local data="hello world"
	local md5="6f5902ac237024bdd0c176cb93063dc4"
	local path="./test/file.txt"

	echo "$data" > $path

	verify "$path" "$md5" >/dev/null

	assertEquals "did not return the correct MD5" 0 $?
	rm "$path"
}

test_verify_with_bad_md5()
{
	local data="hello world"
	local md5="4101bef8794fed986e95dfb54850c68b"
	local path="./test/file.txt"

	echo "$data" > $path

	verify "$path" "$md5" >/dev/null 2>/dev/null

	assertEquals "did not reject the incorrect MD5" 1 $?
	rm "$path"
}

SHUNIT_PARENT=$0 . $SHUNIT2
