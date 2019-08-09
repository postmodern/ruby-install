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
		pacman)
			local missing_pkgs=($(pacman -T "$@"))

			if (( ${#missing_pkgs[@]} > 0 )); then
				installer -S "${missing_pkgs[@]}" || return $?
			fi
			;;
		"")	    warn "Could not determine Package Manager. Proceeding anyway." ;;
		brew)   installer install "$@" || installer upgrade "$@" || return $? ;;
		zypper) installer -n in -l $* || return $? ;;
		*)      installer install -y "$@" || return $?;;
	esac
}

function installer() {
	p="$(command -v $package_manager)"
	pkg_manager_owner="$((stat -c %U $p || stat -f %Su $p) 2>/dev/null )"

	if [ "$(id -un)" == "$pkg_manager_owner" ]; then
		$package_manager "$@"
	else
		sudo -u "$pkg_manager_owner" $package_manager "$@"
	fi
}

detect_package_manager
