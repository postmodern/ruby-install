if [[ -z "$SHUNIT2" ]]; then
	if [[ -f /usr/share/shunit2/shunit2 ]]; then
		SHUNIT2=/usr/share/shunit2/shunit2
	elif shunit2="$(command -v shunit2)"
		SHUNIT2="$shunit2"
	else
		echo "$0: shunit2 is not installed." >&2
		exit 1
	fi
fi

test_fixtures_dir="$PWD/test/fixtures"

export HOME="$test_fixtures_dir/home"
export PATH="$PWD/bin:$PATH"

mkdir -p "$HOME"

. $PWD/share/ruby-install/ruby-install.sh

function oneTimeSetUp() { return; }
function setUp() { return; }
function tearDown() { return; }
function oneTimeTearDown() { return; }
