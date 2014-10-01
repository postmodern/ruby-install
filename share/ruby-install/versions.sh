function is_valid_version()
{
	grep --quiet --line-regexp "$1" "$ruby_dir/versions.txt"
}

function stable_version()
{
	local stable_versions

	readarray stable_versions < "$ruby_dir/stable.txt"

	if [[ -z "$1" ]]; then
		echo "${stable_versions[$((${#stable_versions[@]}-1))]}"
		return
	fi

	local match

	for version in "${stable_versions[@]}"; do
		if [[ "$version" == "$1".* || "$version" == "$1"-* ]]; then
			match="$version"
		fi
	done

	echo -n "$match"
}

function resolve_version()
{
	if is_valid_version "$1"; then
		echo "$1"
	else
		stable_version "$1"
	fi
}
