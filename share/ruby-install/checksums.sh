md5sum="$(command -v md5sum    || echo "$(command -v md5) -r")"
sha1sum="$(command -v sha1sum  || echo "$(command -v sha1) -r")"
sha256sum="$(command -v sha256sum || echo "$(command -v sha256) -r")"
sha512sum="$(command -v sha512sum || echo "$(command -v sha512) -r")"

function lookup_checksum()
{
	local checksums="$1"
	local file="${2##*/}"
	local output="$(grep "  $file" "$checksums")"

	echo -n "${output%% *}"
}

function compute_checksum()
{
	local algorithm="$1"
	local file="$2"

	case "$algorithm" in
		md5)	output="$($md5sum "$file")" ;;
		sha1)	output="$($sha1sum "$file")" ;;
		sha256)	output="$($sha256sum "$file")" ;;
		sha512)	output="$($sha512sum "$file")" ;;
		*)
			return 1
			;;
	esac

	echo -n "${output%% *}"
}

function verify_checksum()
{
	local algorithm="$1"
	local file="$2"
	local checksums="$3"

	local expected_checksum="$(lookup_checksum "$checksums" "$file")"

	if [[ -z "$expected_checksum" ]]; then
		warn "No checksum for $ruby_archive"
		return
	fi

	local actual_checksum="$(compute_checksum "$algorithm" "$file")"

	if [[ "$actual_checksum" != "$expected_checksum" ]]; then
		error "Invalid checksum for $ruby_archive"
		error "  expected: $expected_checksum"
		error "  actual:   $actual_checksum"
		return 1
	fi
}
