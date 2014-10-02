function is_valid_version()
{
	local version="$1"
	local file="$2"

	grep --quiet --line-regexp "$version" "$file"
}

function stable_version()
{
	local key="$1"
	local file="$2"

	local stable_versions

	readarray stable_versions < "$file"

	if [[ -z "$key" ]]; then
		echo -n "${stable_versions[$((${#stable_versions[@]}-1))]}"
		return
	fi

	local match

	for version in "${stable_versions[@]}"; do
		if [[ "$version" == "$key".* || "$version" == "$key"-* ]]; then
			match="$version"
		fi
	done

	echo -n "$match"
}

function resolve_version()
{
	local version="$1"
	local versions_file="$2"
	local stable_file="$2"

	if is_valid_version "$version" "$versions_file"; then
		echo -n "$1"
	else
		stable_version "$version" "$stable_file"
	fi
}
