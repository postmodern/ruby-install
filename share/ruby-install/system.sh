#!/usr/bin/env bash

os_platform="$(uname -s)"
os_arch="$(uname -m)"

#
# Auto-detect the downloader.
#
if   command -v wget >/dev/null; then downloader="wget"
elif command -v curl >/dev/null; then downloader="curl"
fi

#
# Don't use sudo if already root.
#
if (( UID == 0 )); then sudo=""
else                    sudo="sudo"
fi

source "$ruby_install_dir/package_manager.sh"
