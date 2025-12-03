#!/usr/bin/env bash

# See https://github.com/truffleruby/truffleruby/blob/master/README.md#dependencies

truffleruby_major="${ruby_version%%.*}"

case "$package_manager" in
	apt)
		ruby_dependencies=(
			make
			gcc
			zlib1g-dev
			ca-certificates
		)
		;;
	dnf|yum|zypper)
		ruby_dependencies=(
			make
			gcc
			zlib-devel
			ca-certificates
		)
		;;
	pacman)
		ruby_dependencies=(
			make
			gcc
			zlib
			ca-certificates
		)
		;;
	port)
		ruby_dependencies=(
			curl-ca-bundle
		)
		;;
	brew)
		ruby_dependencies=(
			ca-certificates
		)
		;;
	pkg)
		ruby_dependencies=(
			gmake
			gcc
			ca-certificates
		)
		;;
	xbps)
		ruby_dependencies=(
			base-devel
			zlib-devel
			ca-certificates
		)
		;;
esac

if (( truffleruby_major < 33 )); then
	case "$package_manager" in
		apt)
			ruby_dependencies+=(
				libssl-dev
				libyaml-dev
			)
			;;
		dnf|yum|xbps)
			ruby_dependencies+=(
				openssl-devel
				libyaml-devel
			)
			;;
		pacman|port|pkg)
			ruby_dependencies+=(
				openssl
				libyaml
			)
			;;
		zypper)
			ruby_dependencies+=(
				libopenssl-devel
				libyaml-devel
			)
			;;
		brew)
			ruby_dependencies+=(
				openssl@3
				libyaml
			)
			;;
	esac
fi
