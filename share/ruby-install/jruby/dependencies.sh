#!/usr/bin/env bash

case "$package_manager" in
	apt) 	ruby_dependencies=(openjdk-21-jre) ;;
	dnf|yum)ruby_dependencies=(java-21-openjdk) ;;
	pacman) ruby_dependencies=(jre21-openjdk) ;;
	zypper) ruby_dependencies=(java-21-openjdk) ;;
	pkg) 	ruby_dependencies=(openjdk21-jre) ;;
	xbps) 	ruby_dependencies=(openjdk-jre) ;;
esac
