. ./test/helper.sh

function test_PACKAGE_MANAGER_with_apt_get()
{
	command -v apt-get >/dev/null || return

	assertEquals "did not detect apt-get" "apt" "$PACKAGE_MANAGER" 
}

function test_PACKAGE_MANAGER_with_yum()
{
	command -v yum >/dev/null || return

	assertEquals "did not detect yum" "yum" "$PACKAGE_MANAGER" 
}

function test_PACKAGE_MANAGER_with_homebrew()
{
	command -v brew >/dev/null || return

	assertEquals "did not detect homebrew" "brew" "$PACKAGE_MANAGER" 
}

function test_DOWNLOADER_with_wget()
{
	command -v wget >/dev/null || return

	assertEquals "did not detect wget" "wget" "$DOWNLOADER" 
}

function test_DOWNLOADER_without_wget_but_with_curl()
{
	(! command -v wget >/dev/null && command -v curl >/dev/null) || return

	assertEquals "did not detect curl" "curl" "$DOWNLOADER" 
}

function test_DOWNLOADER_with_md5sum()
{
	command -v md5sum >/dev/null || return

	assertEquals "did not detect md5sum" "md5sum" "$MD5SUM" 
}

function test_DOWNLOADER_without_md5sum_but_with_md5()
{
	(! command -v md5sum >/dev/null && command -v md5 >/dev/null) || return

	assertEquals "did not detect md5" "md5" "$MD5SUM" 
}

SHUNIT_PARENT=$0 . $SHUNIT2
