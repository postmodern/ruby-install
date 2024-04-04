#!/usr/bin/env bash

case "$package_manager" in
	apt) 	ruby_dependencies=(openjdk-8-jdk) ;;
	dnf|yum)ruby_dependencies=(java-openjdk) ;;
	pacman) ruby_dependencies=(jre8-openjdk) ;;
	zypper) ruby_dependencies=(java-1.8.0-openjdk) ;;
	pkg) 	ruby_dependencies=(openjdk) ;;
	xbps) 	ruby_dependencies=(openjdk) ;;
esac
