#!/usr/bin/env bash

function set_package_manager()
{
	case "$1" in
		zypper|apt|dnf|yum|pkg|port|brew|pacman)
			package_manager="$1"
			;;
		*)
			error "Unsupported package manager: $1"
			return 1
			;;
	esac
}

function install_packages()
{
	case "$package_manager" in
		apt)	$sudo apt-get install -y "$@" || return $? ;;
		dnf|yum)$sudo $package_manager install -y "$@" || return $?     ;;
		port)   $sudo port install "$@" || return $?       ;;
		pkg)	$sudo pkg install -y "$@" || return $?     ;;
		brew)
			local brew_owner="$(/usr/bin/stat -f %Su "$(command -v brew)")"
			local installed=$(sudo -u "$brew_owner" brew list -1)
			local -a missing_pkgs

			for dep in "$@"; do
				[[ "$installed" =~ [[:space:]]"$dep" ]] || missing_pkgs+=($dep)
			done

			if (( ${#missing_pkgs[@]} > 0 )); then
				sudo -u "$brew_owner" brew install "${missing_pkgs[@]}" ||
				sudo -u "$brew_owner" brew upgrade "${missing_pkgs[@]}" || return $?
			fi
			;;
		pacman)
			local missing_pkgs=($(pacman -T "$@"))

			if (( ${#missing_pkgs[@]} > 0 )); then
				$sudo pacman -S "${missing_pkgs[@]}" || return $?
			fi
			;;
		zypper) $sudo zypper -n in -l $* || return $? ;;
		"")	warn "Could not determine Package Manager. Proceeding anyway." ;;
	esac
}
