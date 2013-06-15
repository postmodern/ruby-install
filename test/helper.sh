[[ -z "$SHUNIT2"     ]] && SHUNIT2=$(git rev-parse --show-toplevel)/test/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

. ./share/ruby-install/ruby-install.sh
. ./share/ruby-install/functions.sh

export PATH="$PWD/bin:$PATH"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
