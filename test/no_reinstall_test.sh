. ./test/helper.sh

setUp()
{
  INSTALL_DIR=`mktemp -d /tmp/ruby-install.XXXX`
  SRC_DIR=`mktemp -d /tmp/ruby-src.XXXX`
}

tearDown()
{
  rmdir $INSTALL_DIR >/dev/null 2>&1
  rmdir $SRC_DIR
}

test_skip_override_with_existing_install_dir()
{
  NO_REINSTALL=1 
  check_overriding >/dev/null 2>&1

  assertEquals "did not return 1" 1 $?
}

test_skip_override_with_nonexisting_install_dir()
{
  INSTALL_DIR="/tmp/foo/bar/baz"

  NO_REINSTALL=1
  check_overriding >/dev/null 2>&1

  assertEquals "did not return 0" 0 $?
}

test_do_not_skip_override()
{
  unset NO_REINSTALL
  check_overriding >/dev/null 2>&1

  assertEquals "did not return 0" 0 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
