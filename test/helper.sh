[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

. ./share/ruby-install/ruby-install.sh
. ./share/ruby-install/functions.sh

export PATH="$PWD/bin:$PATH"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
