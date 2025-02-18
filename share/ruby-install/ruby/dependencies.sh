#!/usr/bin/env bash

case "$package_manager" in
	apt)
		ruby_dependencies=(
			xz-utils
			build-essential
			bison
			zlib1g-dev
			libyaml-dev
			libssl-dev
			libreadline-dev
			libncurses-dev
			libffi-dev
		)
		;;
	dnf|yum)
		ruby_dependencies=(
			xz
			gcc
			automake
			bison
			zlib-devel
			libyaml-devel
			openssl-devel
			readline-devel
			ncurses-devel
			libffi-devel
		)
		;;
	pacman)
		ruby_dependencies=(
			xz
			gcc
			make
			bison
			zlib
			ncurses
			openssl
			readline
			libyaml
			libffi
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
			readline-devel
			ncurses-devel
			libffi-devel
		)
		;;
	brew|port)
		ruby_dependencies=(
			xz
			automake
			bison
			readline
			libyaml
			libffi
		)
		;;
	pkg)
		ruby_dependencies=(
			openssl
			readline
			libyaml
			libffi
		)
		;;
	xbps)
		ruby_dependencies=(
			base-devel
			openssl-devel
			zlib-devel
			libyaml-devel
			readline-devel
			ncurses-devel
			libffi-devel
		)
		;;
esac

if [[ "$ruby_version" < "3.1.0" ]]; then
	case "$package_manager" in
		apt)			ruby_dependencies+=(libgdbm-dev) ;;
		dnf|yum|zypper|xbps)	ruby_dependencies+=(gdbm-devel) ;;
		*)			ruby_dependencies+=(gdbm) ;;
	esac
fi

case "$package_manager" in
	brew|port)
		case "$ruby_version" in
			1.8|2.[0-3])	openssl_version="1.0" ;;
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
	brew)
		openssl_package="openssl@${openssl_version}"
		[[ "${openssl_version}" == 1.* ]] && openssl_package="rbenv/tap/${openssl_package}"
		ruby_dependencies+=("${openssl_package}")
		;;
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
