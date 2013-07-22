. ./test/helper.sh

test_PACKAGE_MANAGER_with_apt_get()
{
	[[ $(command -v apt-get) ]] || return

	assertEquals "did not detect apt-get" "apt" "$PACKAGE_MANAGER" 
}

test_PACKAGE_MANAGER_with_yum()
{
	[[ $(command -v yum) ]] || return

	assertEquals "did not detect yum" "yum" "$PACKAGE_MANAGER" 
}

test_PACKAGE_MANAGER_with_homebrew()
{
	[[ $(command -v brew) ]] || return

	assertEquals "did not detect homebrew" "brew" "$PACKAGE_MANAGER" 
}

test_DOWNLOADER_with_wget()
{
	[[ $(command -v wget) ]] || return

	assertEquals "did not detect wget" "wget" "$DOWNLOADER" 
}

test_DOWNLOADER_without_wget_but_with_curl()
{
	[[ ! $(command -v wget) && $(command -v curl) ]] || return

	assertEquals "did not detect curl" "curl" "$DOWNLOADER" 
}

test_DOWNLOADER_with_md5sum()
{
	[[ $(command -v md5sum) ]] || return

	assertEquals "did not detect md5sum" "md5sum" "$MD5SUM" 
}

test_DOWNLOADER_without_md5sum_but_with_md5()
{
	[[ ! $(command -v md5sum) && $(command -v md5) ]] || return

	assertEquals "did not detect md5" "md5" "$MD5SUM" 
}

SHUNIT_PARENT=$0 . $SHUNIT2
