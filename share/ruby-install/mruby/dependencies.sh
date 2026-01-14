#!/usr/bin/env bash

case "$package_manager" in
	apt)
		ruby_dependencies=(
			ruby
			rake
			build-essential
			bison
		)
		;;
	dnf|yum|zypper)
		ruby_dependencies=(
			ruby
			rubygem-rake
			gcc
			make
			bison
		)
		;;
	pacman)
		ruby_dependencies=(
			ruby
			ruby-rake
			gcc
			make
			bison
		)
		;;
	pkg)
		ruby_dependencies=(
			ruby
			rubygem-rake
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
