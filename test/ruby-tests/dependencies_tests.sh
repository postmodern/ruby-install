#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/ruby-install.sh

function setUp()
{
	ruby="ruby"
	ruby_version="3.4.0"
}

function test_when_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "xz-utils build-essential zlib1g-dev libyaml-dev libssl-dev libncurses-dev libffi-dev" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "xz gcc automake zlib-devel libyaml-devel openssl-devel ncurses-devel libffi-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	package_manager="yum"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "xz gcc automake zlib-devel libyaml-devel openssl-devel ncurses-devel libffi-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pacman()
{
	local original_package_manager="$package_manager"
	package_manager="pacman"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "xz gcc make zlib ncurses openssl libyaml libffi" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	package_manager="zypper"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "xz gcc make automake zlib-devel libyaml-devel libopenssl-devel ncurses-devel libffi-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_pkg()
{
	local original_package_manager="$package_manager"
	package_manager="pkg"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "openssl libyaml libffi" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertNull "accidentally set \$openssl_version" \
	           "$openssl_version"

	assertEquals "did not correctly set \$ruby_dependencies" \
		     "base-devel openssl-devel zlib-devel libyaml-devel ncurses-devel libffi-devel" \
		     "${ruby_dependencies[*]}"

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add bison to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" bison "* ]]'

	assertTrue "did not add libreadline-dev to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" libreadline-dev "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add bison to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" bison "* ]]'

	assertTrue "did not add readline-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	package_manager="yum"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add bison to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" bison "* ]]'

	assertTrue "did not add readline-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	package_manager="zypper"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add readline-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add readline-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_pacman()
{
	local original_package_manager="$package_manager"
	package_manager="pacman"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add bison to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" bison "* ]]'

	assertTrue "did not add readline to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_brew()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add bison to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" bison "* ]]'

	assertTrue "did not add readline to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_port()
{
	local original_package_manager="$package_manager"
	package_manager="port"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add bison to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" bison "* ]]'

	assertTrue "did not add readline to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_3_0_and_package_manager_is_pkg()
{
	local original_package_manager="$package_manager"
	package_manager="pkg"
	ruby_version="3.2.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add readline to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" readline "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_1_0_and_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	package_manager="apt"
	ruby_version="3.0.7"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add libgdbm-dev to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" libgdbm-dev "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_1_0_and_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	package_manager="dnf"
	ruby_version="3.0.7"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add gdbm-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" gdbm-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_1_0_and_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	package_manager="yum"
	ruby_version="3.0.7"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add gdbm-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" gdbm-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_1_0_and_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	package_manager="zypper"
	ruby_version="3.0.7"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add gdbm-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" gdbm-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_1_0_and_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	package_manager="xbps"
	ruby_version="3.0.7"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add gdbm-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" gdbm-devel "* ]]'

	package_manager="$original_package_manager"
}

function test_when_ruby_version_is_less_than_3_1_0_and_package_manager_is_other()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="3.0.7"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not add gdbm-devel to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" gdbm "* ]]'

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_brew_and_ruby_version_is_less_than_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="3.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "1.1" \
		     "$openssl_version"

	assertTrue "did not add openssl@1.1 to \$ruby_dependencies" \
	             '[[ " ${ruby_dependencies[*]} " == *" openssl@1.1 "* ]]'

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_brew_and_ruby_version_is_greater_equal_to_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="brew"
	ruby_version="3.1.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "3" \
		     "$openssl_version"

	assertTrue "did not add openssl@3 to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" openssl@3 "* ]]'

	package_manager="$original_package_manager"
}

function test_when_package_manager_is_port_and_ruby_version_is_less_than_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="port"
	ruby_version="3.0.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "1.1" \
		     "$openssl_version"

	assertTrue "did not add openssl11 to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" openssl11 "* ]]'

	package_manager="$original_package_manager"
}

function test_package_manager_is_port_and_ruby_version_is_greater_equal_to_3_1_0()
{
	local original_package_manager="$package_manager"
	package_manager="port"
	ruby_version="3.1.0"

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertEquals "did not correctly set \$openssl_version" \
	             "3" \
		     "$openssl_version"

	assertTrue "did not add openssl3 to \$ruby_dependencies" \
	           '[[ " ${ruby_dependencies[*]} " == *" openssl3 "* ]]'

	package_manager="$original_package_manager"
}

function test_ruby_dependencies_when_with_jemalloc_is_given_and_package_manager_is_apt()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="apt"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain libjemalloc-dev" \
		   '[[ " ${ruby_dependencies[*]} " == *" libjemalloc-dev "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_with_jemalloc_is_given_and_package_manager_is_dnf()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="dnf"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain jemalloc-devel" \
		   '[[ " ${ruby_dependencies[*]} " == *" jemalloc-devel "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_with_jemalloc_is_given_and_package_manager_is_yum()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="yum"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain jemalloc-devel" \
		   '[[ " ${ruby_dependencies[*]} " == *" jemalloc-devel "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_with_jemalloc_is_given_and_package_manager_is_port()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="port"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain jemalloc-devel" \
		   '[[ " ${ruby_dependencies[*]} " == *" jemalloc-devel "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_with_jemalloc_is_given_and_package_manager_is_xbps()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="xbps"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain jemalloc-devel" \
		   '[[ " ${ruby_dependencies[*]} " == *" jemalloc-devel "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_with_jemalloc_is_given_and_package_manager_is_zypper()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="zypper"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain libjemalloc2" \
		   '[[ " ${ruby_dependencies[*]} " == *" libjemalloc2"* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_with_jemalloc_is_given()
{
	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="pkg"
	configure_opts=(--with-jemalloc)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain jemalloc" \
		   '[[ " ${ruby_dependencies[*]} " == *" jemalloc"* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_enable_yjit_is_given_and_rustc_is_not_installed_and_the_package_manager_is_apt()
{
	command -v rustc && return

	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="apt"
	configure_opts=(--enable-yjit)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain rustc to the dependencies" \
		   '[[ " ${ruby_dependencies[*]} " == *" rustc "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_enable_yjit_is_given_and_rustc_is_not_installed_and_the_package_manager_is_not_apt()
{
	command -v rustc >/dev/null && return

	local original_package_manager="$package_manager"
	local original_configure_opts=("${configure_opts[@]}")

	package_manager="dnf"
	configure_opts=(--enable-yjit)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did not contain rust to the dependencies" \
		   '[[ " ${ruby_dependencies[*]} " == *" rust "* ]]'

	package_manager="$original_package_manager"
	configure_opts=("${original_configure_opts[@]}")
}

function test_ruby_dependencies_when_enable_yjit_is_given_but_rustc_is_installed()
{
	command -v rustc >/dev/null || return

	local original_configure_opts=("${configure_opts[@]}")

	configure_opts=(--enable-yjit)

	source "$ruby_install_dir/$ruby/dependencies.sh"

	assertTrue "did accidentally add rustc to the dependencies" \
		   '[[ ! " ${ruby_dependencies[*]} " == *" rustc "* ]]'

	assertTrue "did accidentally add rust to the dependencies" \
		   '[[ ! " ${ruby_dependencies[*]} " == *" rust "* ]]'

	configure_opts=("${original_configure_opts[@]}")
}

function tearDown()
{
	unset ruby ruby_version ruby_dependencies openssl_version
}

SHUNIT_PARENT=$0 . $SHUNIT2
