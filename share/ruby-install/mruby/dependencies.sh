#!/usr/bin/env bash

case "$package_manager" in
	apt)
		ruby_dependencies=(
			build-essential
			bison
		)
		;;
	dnf|yum|pacman|zypper)
		ruby_dependencies=(
			gcc
			make
			bison
		)
		;;
	pkg)
		ruby_dependencies=(
			gcc
			automake
			bison
		)
		;;
	brew|port)	ruby_dependencies=(bison) ;;
	xbps)		ruby_dependencies=(base-devel) ;;
esac
