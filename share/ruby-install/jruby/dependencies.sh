#!/usr/bin/env bash

ruby_dependencies=()

# NOTE: only install OpenJDK JRE if java isn't already installed.
if ! command -v java >/dev/null; then
	case "$package_manager" in
		apt) 	ruby_dependencies+=(openjdk-21-jre) ;;
		dnf|yum)ruby_dependencies+=(java-21-openjdk) ;;
		pacman) ruby_dependencies+=(jre21-openjdk) ;;
		zypper) ruby_dependencies+=(java-21-openjdk) ;;
		pkg) 	ruby_dependencies+=(openjdk21-jre) ;;
		xbps) 	ruby_dependencies+=(openjdk-jre) ;;
	esac
fi
