. ./test/helper.sh

test_PACKAGE_MANAGER_with_apt_get()
{
	[[ $(type -t apt-get) ]] || return

	assertEquals "did not detect apt-get" "apt" "$PACKAGE_MANAGER" 
}

test_PACKAGE_MANAGER_with_yum()
{
	[[ $(type -t yum) ]] || return

	assertEquals "did not detect yum" "yum" "$PACKAGE_MANAGER" 
}

test_PACKAGE_MANAGER_with_homebrew()
{
	[[ $(type -t brew) ]] || return

	assertEquals "did not detect homebrew" "brew" "$PACKAGE_MANAGER" 
}

test_DOWNLOADER_with_wget()
{
	[[ $(type -t wget) ]] || return

	assertEquals "did not detect wget" "wget" "$DOWNLOADER" 
}

test_DOWNLOADER_without_wget_but_with_curl()
{
	[[ ! $(type -t wget) && $(type -t curl) ]] || return

	assertEquals "did not detect curl" "curl" "$DOWNLOADER" 
}

test_DOWNLOADER_with_md5sum()
{
	[[ $(type -t md5sum) ]] || return

	assertEquals "did not detect md5sum" "md5sum" "$MD5SUM" 
}

test_DOWNLOADER_without_md5sum_but_with_md5()
{
	[[ ! $(type -t md5sum) && $(type -t md5) ]] || return

	assertEquals "did not detect md5" "md5" "$MD5SUM" 
}

SHUNIT_PARENT=$0 . $SHUNIT2
