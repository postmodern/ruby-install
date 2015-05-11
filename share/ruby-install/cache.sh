cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/ruby-install"
cache_url="https://raw.githubusercontent.com/postmodern/ruby-versions/master"

function cache_is_stale()
{
	local file="$cache_dir/$1"
	local now="$(date +%s)"
	local one_hour_ago="$(( now - 60 * 60 ))"

	[[ ! -f "$file" ]] || (( $(stat -c %Y "$file") < $one_hour_ago ))
}

function cache_download()
{
	local file="$1"

	download "$cache_url/$file" "$cache_dir/$file" >/dev/null 2>&1 || return $?
}

function cache_delete()
{
	local file="$1"

	rm -f "$cache_dir/$file"
}

function cache_update()
{
	local file="$1"

	if cache_is_stale "$file"; then
		cache_delete "$file"   || return $?
		cache_download "$file" || return $?
	fi
}

function cache_update_versions()
{
	local ruby="$1"

	cache_update "$ruby/versions.txt" || return $?
}

function cache_update_stable_versions()
{
	local ruby="$1"
	
	cache_update "$ruby/stable.txt" || return $?
}

function cache_update_checksums()
{
	local ruby="$1"

	for algorithm in md5 sha1 sha256 sha512; do
		cache_update "$ruby/checksums.$algorithm" || return $?
	done
}

function cache_update_ruby()
{
	local ruby="$1"

	cache_update_versions "$ruby"
	cache_update_stable_versions "$ruby"
	cache_update_checksums "$ruby"
}
