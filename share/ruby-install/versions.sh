unset GREP_OPTIONS GREP_COLOR GREP_COLORS

function is_known_version()
{
	local file="$1"
	local version="$2"

	grep -q -x "$version" "$file"
}

function latest_version()
{
	local file="$1"
	local key="$2"

	if [[ -z "$key" ]]; then
		tail -n 1 "$file"
		return
	fi

	local version match=""

	while IFS="" read -r version; do
		if [[ "$version" == "$key".* || "$version" == "$key"-* ]]; then
			match="$version"
		fi
	done < "$file"

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

	if [[ -z "$version" ]]; then
		latest_version "$latest_versions_file"
	elif is_known_version "$versions_file" "$version"; then
		echo -n "$version"
	else
		latest_version "$latest_versions_file" "$version" ||
		echo -n "$version"
	fi
}
