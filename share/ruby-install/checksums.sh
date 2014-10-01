supported_checksums=()
checksum_programs=()

for algorithm in md5 sha1 sha256 sha512; do
	for program in "${algorithm}sum" "$algorithm"; do
		if command -v "$program" >/dev/null; then
			supported_checksums+=("$algorithm")
			checksum_programs+=("$program")
			break
		fi
	done
done

function lookup_checksum()
{
	local file="$1"
	local algorithm="$2"
	local checksums="$ruby_dir/checksums.$algorithm"
	local output="$(grep "  $file" "$checksums")"

	echo -n "${output%%  *}"
}

function compute_checksum()
{
	local program="$1"
	local file="$src_dir/$2"
	local output="$("$program" "$file")"

	echo -n "${output%%  *}"
}

function verify_ruby_checksum()
{
	local algorithm="$1"
	local program="$2"
	local expected_checksum="$(lookup_checksum "$ruby_archive" "$algorithm")"

	if [[ -z "$expected_checksum" ]]; then
		warn "No $algorithm checksum for $ruby_archive"
		return
	fi

	local actual_checksum="$(compute_checksum "$program" "$ruby_archive")"

	if [[ "$actual_checksum" != "$expected_checksum" ]]; then
		error "Invalid $algorithm checksum for $ruby_archive"
		error "  expected: $expected_checksum"
		error "  actual:   $actual_checksum"
		return 1
	fi
}

function verify_ruby()
{
	if (( ${#supported_checksums[@]} == 0 )); then
		warn "No checksums for $ruby!"
		return
	fi

	local algorithm program

	log "Verifying $ruby_archive ..."

	for i in $(seq 0 $(( ${#supported_checksums[@]} - 1 ))); do
		algorithm="${supported_checksums[$i]}"
		program="${checksum_programs[$i]}"

		verify_ruby_checksum "$algorithm" "$program" || return $?
	done
}
