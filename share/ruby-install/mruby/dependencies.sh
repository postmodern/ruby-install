#!/usr/bin/env bash

case "$package_manager" in
	apt)
		ruby_dependencies=(
			ruby
			build-essential
			bison
		)
		;;
	dnf|yum|pacman|zypper)
		ruby_dependencies=(
			ruby
			gcc
			make
			bison
		)
		;;
	pkg)
		ruby_dependencies=(
			ruby
			gcc
			automake
			bison
		)
		;;
	xbps)
		ruby_dependencies=(
			ruby
			base-devel
		)
		;;
	brew|port)	ruby_dependencies=(bison) ;;
esac
