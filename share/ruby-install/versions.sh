function is_valid_version()
{
	local version="$1"
	local file="$2"

	grep -q -x "$version" "$file"
}

function latest_version()
{
	local key="$1"
	local file="$2"

	local stable_versions

	readarray -t stable_versions < "$file"

	if [[ -z "$key" ]]; then
		echo -n "${stable_versions[$((${#stable_versions[@]}-1))]}"
		return
	fi

	local match=""

	for version in "${stable_versions[@]}"; do
		if [[ "$version" == "$key".* || "$version" == "$key"-* ]]; then
			match="$version"
		fi
	done

	if [[ -n "$match" ]]; then
		echo -n "$match"
	else
		return 1
	fi
}

function resolve_version()
{
	local version="$1"
	local versions_file="$2"
	local latest_versions_file="$3"

	if is_valid_version "$version" "$versions_file"; then
		echo -n "$version"
	else
		latest_version "$version" "$latest_versions_file" ||
		echo -n "$version"
	fi
}
