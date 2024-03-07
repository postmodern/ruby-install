#!/usr/bin/env bash

case "$package_manager" in
	apt)
		ruby_dependencies=(
			build-essential
			bison
		)
		;;
	dnf)
		ruby_dependencies=(
			gcc
			make
			bison
		)
		;;
	yum)
		ruby_dependencies=(
			gcc
			make
			bison
		)
		;;
	port)	ruby_dependencies=(bison) ;;
	brew)	ruby_dependencies=(bison) ;;
	pacman)
		ruby_dependencies=(
			gcc
			make
			bison
		)
		;;
	zypper)
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
	xbps)  ruby_dependencies=(base-devel) ;;
esac
