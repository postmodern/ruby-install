#!/usr/bin/env bash

case "$package_manager" in
	apt)
		ruby_dependencies=(
			xz-utils
			build-essential
			zlib1g-dev
			libyaml-dev
			libssl-dev
			libncurses-dev
			libffi-dev
			libgmp-dev
		)
		;;
	dnf|yum)
		ruby_dependencies=(
			xz
			gcc
			automake
			zlib-devel
			libyaml-devel
			openssl-devel
			ncurses-devel
			libffi-devel
			gmp-devel
		)
		;;
	pacman)
		ruby_dependencies=(
			xz
			gcc
			make
			zlib
			ncurses
			openssl
			libyaml
			libffi
			gmp
		)
		;;
	zypper)
		ruby_dependencies=(
			xz
			gcc
			make
			automake
			zlib-devel
			libyaml-devel
			libopenssl-devel
			ncurses-devel
			libffi-devel
			gmp-devel
		)
		;;
	brew|port)
		ruby_dependencies=(
			xz
			automake
			libyaml
			libffi
			gmp
		)
		;;
	pkg)
		ruby_dependencies=(
			openssl
			libyaml
			libffi
			gmp
		)
		;;
	xbps)
		ruby_dependencies=(
			base-devel
			openssl-devel
			zlib-devel
			libyaml-devel
			ncurses-devel
			libffi-devel
			gmp-devel
		)
		;;
esac

#
# Add bison and readline as a dependencies for ruby < 3.3.0.
#
if [[ "$ruby_version" < "3.3.0" ]]; then
	case "$package_manager" in
		apt|dnf|yum|pacman|brew|port)
			ruby_dependencies+=(bison)
			;;
	esac

	case "$package_manager" in
		apt)
			ruby_dependencies+=(libreadline-dev)
			;;
		dnf|yum|zypper|xbps)
			ruby_dependencies+=(readline-devel)
			;;
		pacman|brew|port|pkg)
			ruby_dependencies+=(readline)
			;;
	esac
fi

#
# Add gdbm as a dependency for ruby < 3.1.0.
#
if [[ "$ruby_version" < "3.1.0" ]]; then
	case "$package_manager" in
		apt)			ruby_dependencies+=(libgdbm-dev) ;;
		dnf|yum|zypper|xbps)	ruby_dependencies+=(gdbm-devel) ;;
		*)			ruby_dependencies+=(gdbm) ;;
	esac
fi

#
# Determine which openssl version family to use for homebrew and macports
# based on the ruby version:
#
# * ruby <= 3.0.0 - openssl 1.1
# * ruby > 3.0.0 - openssl 3.x
#
case "$package_manager" in
	brew|port)
		case "$ruby_version" in
			2.*|3.0.*)	openssl_version="1.1" ;;
			*)		openssl_version="3" ;;
		esac
		;;
esac

#
# Install openssl@1.1 or openssl@3.0 depending on the Ruby version,
# only for homebrew.
#
case "$package_manager" in
	brew)	ruby_dependencies+=("openssl@${openssl_version}") ;;
	port)	ruby_dependencies+=("openssl${openssl_version/./}") ;;
esac

#
# Install libjemalloc and C header files for --with-jemalloc support.
#
if [[ " ${configure_opts[*]} " == *" --with-jemalloc "* ]]; then
	case "$package_manager" in
		apt)
			ruby_dependencies+=(libjemalloc-dev)
			;;
		dnf|yum|port|xbps)
			ruby_dependencies+=(jemalloc-devel)
			;;
		zypper)
			ruby_dependencies+=(libjemalloc2)
			;;
		*)
			ruby_dependencies+=(jemalloc)
			;;
	esac
fi

#
# Install Rust if YJIT support is explicitly enabled.
#
if [[ " ${configure_opts[*]} " == *" --enable-yjit "* ]]; then
	# NOTE: YJIT is written in Rust, thus requires rustc
	if ! command -v rustc >/dev/null; then
		case "$package_manager" in
			apt) ruby_dependencies+=(rustc) ;;
			*)   ruby_dependencies+=(rust) ;;
		esac
	fi
fi
