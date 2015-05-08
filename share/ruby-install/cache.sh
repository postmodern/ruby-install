cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/ruby-install"
cache_url="https://raw.github.com/postmodern/ruby-versions/master"

function cache_download()
{
	local file="$1"
	local url="$cache_url/$file"


	case "$downloader" in
		wget)
			wget -q -N -x -nH --cut-dirs 3 -P "$cache_dir" "$url" || return $?
			;;
		curl)
			local path="$cache_dir/$file"

			mkdir -p "${path%/*}"
			curl -s -f -L -z "$path" -o "$path" "$url" || return $?
			;;
		*)
			error "Could not find wget or curl"
			return 1
			;;
	esac
}

function cache_update_ruby()
{
	local ruby="$1"

	cache_download "$ruby/versions.txt" || return $?
	cache_download "$ruby/stable.txt"   || return $?

	for algorithm in md5 sha1 sha256 sha512; do
		cache_download "$ruby/checksums.$algorithm" || return $?
	done
}

function cache_update_rubies()
{
	for ruby in "${rubies[@]}"; do
		cache_update_ruby "$ruby" || return $?
	done
}
