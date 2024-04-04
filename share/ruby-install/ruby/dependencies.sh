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
			libgdbm-dev
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
			gdbm-devel
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
			gdbm
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
			gdbm-devel
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
			gdbm
			libffi
		)
		;;
	pkg)
		ruby_dependencies=(
			openssl
			readline
			libyaml
			gdbm
			libffi
		)
		;;
	xbps)
		ruby_dependencies=(
			base-devel
			openssl-devel
			zlib-devel
			libyaml-devel
			gdbm-devel
			readline-devel
			ncurses-devel
			libffi-devel
		)
		;;
esac

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
