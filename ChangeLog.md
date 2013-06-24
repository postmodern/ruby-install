### 0.2.0 / 2013-06-23

* Added support for installing [MagLev] (@havenwood).
* Added the `--url` option to specify an alternate URL for the Ruby archive.
* Added the `--md5` option to specify an alternate MD5 checksum for the Ruby
  archive.
* Added the `--no-download` option to use the previously downloaded Ruby
  archive.
* Added the `--no-verify` option to disable verifying the downloaded Ruby
  archive.
* Added the `--no-install-deps` option to bypass using the package manager.
  (Stefano Zanella)
* Added the `--no-reinstall` option to prevent overwriting existing Ruby
  installs. (Stefano Zanella)
* Allow `curl` to follow redirects. (Stefano Zanella)
* No longer sync the package manager.
* Ensure that the parent of the installation directory exists (@havenwood).

#### ruby

* Set the default version to 2.0.0-p195.

#### rubinius

* Fixed homebrew dependencies (thanks Jack Nagel).
* No longer install libffi, since Rubinius vendors their own version.

### 0.1.4 / 2013-05-31

#### ruby/functions.sh

* Pass the paths to homebrew packages to `./configure` using the
  `--with-opt-dir` option.

#### rubinius/functions.sh

* Pass the paths to homebrew packages to `./configure` using the
  `--with-opt-dir` option.

### 0.1.3 / 2013-05-30

* Fixed typo in auto-detection of homebrew (Jack Nagel).

#### functions.sh

* `cd` into the extracted Ruby directory at the end of the `extract_ruby`
  function. This allows the JRuby build script to override `extract_ruby` and
  entirely skip the extract, configure and compile steps.

### 0.1.2 / 2013-05-30

* Added a `setup.sh` script which installs `ruby-install`, then installs
  Ruby, JRuby and Rubinius.

#### functions.sh

* Fixed the `curl` command within the `download` function (Greg Karékinian).

### 0.1.1 / 2013-05-28

* Fixed multiple bugs where code was still using the old `$PACKAGE_MANAGER`
  variable instead of checking for specific package managers.

#### rubinius/functions.sh

* Added `pacman` dependencies for building Rubinius on Arch Linux.

### 0.1.0 / 2013-05-28

* Initial release:
  * Supports installing arbitrary versions.
  * Supports installing into `/opt/rubies/` for root and `~/.rubies/` for users
    by default.
  * Supports installing into arbitrary directories.
  * Supports applying arbitrary patches.
  * Supports specifying arbitrary `./configure` options.
  * Supports downloading archives using `wget` or `curl`.
  * Supports verifying downloaded archives using `md5sum` or `md5`.
  * Supports installing build dependencies via the package manager:
    * [apt]
    * [yum]
    * [pacman]
    * [brew]

[apt]: http://wiki.debian.org/Apt
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[brew]: http://mxcl.github.com/homebrew/
