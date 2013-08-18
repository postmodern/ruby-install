. ./test/helper.sh

DATA="hello world"
MD5="6f5902ac237024bdd0c176cb93063dc4"
FILE="./test/file.txt"

function setUp()
{
	echo "$DATA" > "$FILE"
}

function test_verify()
{
	verify "$FILE" "$MD5" >/dev/null

	assertEquals "did not return the correct MD5" 0 $?
}

function test_verify_without_md5()
{
	verify "$FILE" "" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_verify_using_md5sum()
{
	command -v md5sum >/dev/null || return

	MD5SUM="md5sum" verify "$FILE" "$MD5" >/dev/null

	assertEquals "did not return the correct MD5" 0 $?
}

function test_verify_using_md5()
{
	command -v md5 >/dev/null || return

	MD5SUM="md5" verify "$FILE" "$MD5" >/dev/null

	assertEquals "did not return the correct MD5" 0 $?
}

function test_verify_with_bad_md5()
{
	verify "$FILE" "4101bef8794fed986e95dfb54850c68b" >/dev/null 2>/dev/null

	assertEquals "did not reject the incorrect MD5" 1 $?
}

function tearDown()
{
	rm "$FILE"
}

SHUNIT_PARENT=$0 . $SHUNIT2
