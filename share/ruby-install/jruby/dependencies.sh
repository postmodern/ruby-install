#!/usr/bin/env bash

ruby_dependencies=()

# NOTE: only install OpenJDK JRE if java isn't already installed.
if ! command -v java >/dev/null; then
	case "$package_manager" in
		apt) 	ruby_dependencies+=(default-jre) ;;
		dnf|yum)ruby_dependencies+=(java-latest-openjdk) ;;
		pacman) ruby_dependencies+=(jre21-openjdk) ;;
		zypper) ruby_dependencies+=(java-21-openjdk) ;;
		xbps) 	ruby_dependencies+=(openjdk-jre) ;;
		brew)	ruby_dependencies+=(openjdk) ;;
		port)	ruby_dependencies+=(openjdk21) ;;
		pkg) 	ruby_dependencies+=(openjdk21-jre) ;;
	esac
fi
