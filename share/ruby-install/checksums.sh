supported_checksums=()

for algorithm in md5 sha1 sha256 sha512; do
	for program in "${algorithm}sum" "$algorithm -r"; do
		if command -v "$program" >/dev/null; then
			supported_checksums+=("$algorithm:$program")
			break
		fi
	done
done

function lookup_checksum()
{
	local checksums="$1"
	local file="${2##*/}"
	local output="$(grep "  $file" "$checksums")"

	echo -n "${output%% *}"
}

function compute_checksum()
{
	local program="$1"
	local file="$2"
	local output="$("$program" "$file")"

	echo -n "${output%% *}"
}

function verify_checksum()
{
	local checksums="$1"
	local file="$2"
	local program="$3"

	local expected_checksum="$(lookup_checksum "$checksums" "$file")"

	if [[ -z "$expected_checksum" ]]; then
		warn "No checksum for $ruby_archive"
		return
	fi

	local actual_checksum="$(compute_checksum "$program" "$file")"

	if [[ "$actual_checksum" != "$expected_checksum" ]]; then
		error "Invalid checksum for $ruby_archive"
		error "  expected: $expected_checksum"
		error "  actual:   $actual_checksum"
		return 1
	fi
}
