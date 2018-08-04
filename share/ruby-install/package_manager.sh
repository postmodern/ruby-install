#!/usr/bin/env bash

#
# Auto-detect the package manager.
#
function detect_package_manager()
{
	if   command -v zypper  >/dev/null; then package_manager="zypper"
	elif command -v apt-get >/dev/null; then package_manager="apt"
	elif command -v dnf     >/dev/null; then package_manager="dnf"
	elif command -v yum     >/dev/null; then package_manager="yum"
	elif command -v pkg     >/dev/null; then package_manager="pkg"
	elif command -v port    >/dev/null; then package_manager="port"
	elif command -v brew    >/dev/null; then package_manager="brew"
	elif command -v pacman  >/dev/null; then package_manager="pacman"
	fi
}

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
			sudo -u "$brew_owner" brew install "$@" ||
			sudo -u "$brew_owner" brew upgrade "$@" || return $?
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

detect_package_manager
