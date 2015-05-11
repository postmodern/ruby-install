cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/ruby-install"

function cache_is_stale()
{
	local file="$cache_dir/$1"

	[[ ! -f "$file" ]] || [[ -n "$(find "$file" -mmin +60)" ]]
}

function cache_download()
{
	local file="$1"
	local base_url="$2"

	download "$base_url/$file" "$cache_dir/$file" >/dev/null 2>&1 || return $?
}

function cache_delete()
{
	local file="$1"

	rm -f "$cache_dir/$file"
}

function cache_update()
{
	local file="$1"
	local base_url="$2"

	cache_delete "$file"   || return $?
	cache_download "$file" "$base_url" || return $?
}
