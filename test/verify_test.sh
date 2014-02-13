. ./test/helper.sh

data="hello world"
md5="6f5902ac237024bdd0c176cb93063dc4"
file="./test/file.txt"

function setUp()
{
	echo "$data" > "$file"
}

function test_verify()
{
	verify "$file" "$md5" >/dev/null

	assertEquals "did not return the correct md5" 0 $?
}

function test_verify_without_md5()
{
	verify "$file" "" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_verify_using_md5sum()
{
	command -v md5sum >/dev/null || return

	md5sum="md5sum" verify "$file" "$md5" >/dev/null

	assertEquals "did not return the correct md5" 0 $?
}

function test_verify_using_md5()
{
	command -v md5 >/dev/null || return

	md5sum="md5" verify "$file" "$md5" >/dev/null

	assertEquals "did not return the correct md5" 0 $?
}

function test_verify_using_openssl()
{
	command -v openssl >/dev/null || return

	md5sum="openssl md5" verify "$file" "$md5" >/dev/null

	assertEquals "did not return the correct md5" 0 $?
}

function test_verify_with_bad_md5()
{
	verify "$file" "4101bef8794fed986e95dfb54850c68b" >/dev/null 2>/dev/null

	assertEquals "did not reject the incorrect md5" 1 $?
}

function tearDown()
{
	rm "$file"
}

SHUNIT_PARENT=$0 . $SHUNIT2
