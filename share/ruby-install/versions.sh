function is_valid_version()
{
	local file="$1"
	local version="$2"

	grep -q -x "$version" "$file"
}

function latest_version()
{
	local file="$1"
	local key="$2"

	local stable_versions

	readarray -t stable_versions < "$file"

	if [[ -z "$key" ]]; then
		echo -n "${stable_versions[$((${#stable_versions[@]}-1))]}"
		return
	fi

	local version match=""

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

	if is_valid_version "$versions_file" "$version"; then
		echo -n "$version"
	else
		latest_version "$latest_versions_file" "$version" ||
		echo -n "$version"
	fi
}
