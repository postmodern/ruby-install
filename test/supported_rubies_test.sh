. ./test/helper.sh

function test_known_rubies()
{
	local output="$(known_rubies)"

	assertTrue "did not include ruby" '[[ "$output" == *ruby* ]]'
	assertTrue "did not include jruby" '[[ "$output" == *jruby* ]]'
	assertTrue "did not include rbx" '[[ "$output" == *rbx* ]]'
	assertTrue "did not include maglev" '[[ "$output" == *maglev* ]]'
	assertTrue "did not include mruby" '[[ "$output" == *mruby* ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
