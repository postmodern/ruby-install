md5sum="$(basename $(command -v md5sum || command -v md5))"
sha1sum="$(basename $(command -v sha1sum || command -v sha1))"
sha256sum="$(basename $(command -v sha256sum || command -v sha256))"
sha512sum="$(basename $(command -v sha512sum || command -v sha512))"

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
	local program

	case "$algorithm" in
		md5)	program="$md5sum" ;;
		sha1)	program="$sha1sum" ;;
		sha256)	program="$sha256sum" ;;
		sha512)	program="$sha512sum" ;;
		*)	return 1 ;;
	esac

	local output="$("$program" "$file")" ;;

	case "$program" in
		md5|sha1|sha256|sha512)
			echo -n "${output##* = }"
		md5sum|sha1sum|sha256sum|sha512sum)
			echo -n "${output%%  *}"
	esac
}

function verify_checksum()
{
	local algorithm="$1"
	local file="$2"
	local checksums="$3"

	local expected_checksum="$(lookup_checksum "$checksums" "$file")"

	if [[ -z "$expected_checksum" ]]; then
		warn "No checksum for $file"
		return
	fi

	local actual_checksum="$(compute_checksum "$algorithm" "$file")"

	if [[ "$actual_checksum" != "$expected_checksum" ]]; then
		error "Invalid checksum for $file"
		error "  expected: $expected_checksum"
		error "  actual:   $actual_checksum"
		return 1
	fi
}
