. ./test/helper.sh

setUp()
{
	auto_detect
}

test_auto_detect_md5()
{
	assertNotNull "did not set \$MD5SUM" $MD5SUM
}

test_auto_detect_download()
{
	assertEquals "did not define download()" "function" $(type -t download)
}

test_auto_detect_package_manager()
{
	assertNotNull "did not set \$PACKAGE_MANAGER" $PACKAGE_MANAGER
}

SHUNIT_PARENT=$0 . $SHUNIT2
