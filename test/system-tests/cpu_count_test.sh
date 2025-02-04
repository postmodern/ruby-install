. ./test/helper.sh
. ./share/ruby-install/system.sh

function test_cpu_count()
{
	assertTrue "did not return a number > 0" '(( $(cpu_count) > 0 ))'
}

SHUNIT_PARENT=$0 . $SHUNIT2
