. ./test/helper.sh

test_supported_rubies()
{
	local output="$(supported_rubies)"

	assertTrue "did not include ruby" '[[ "$output" == *ruby* ]]'
	assertTrue "did not include jruby" '[[ "$output" == *jruby* ]]'
	assertTrue "did not include rubinius" '[[ "$output" == *rubinius* ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
