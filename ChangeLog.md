### 0.3.2 / 2013-11-22

* Exit normally when `--no-reinstall` is specified and the ruby has already
  been installed. (@cbandy)
* `fetch()` can now strip trailing tabs as well as spaces.

#### ruby

* Added version aliases for `2` and `1`.
* Added versions 1.9.3-p484, 2.0.0-p353 and 2.1.0-preview2 for CVE-2013-4164.

#### jruby

* Added versions 1.7.6, 1.7.7 and 1.7.8.

#### rubinius

* Drop support for installing 2.0.0, due to multiple bugs.
* Added versions 2.1.1, 2.2.0 and 2.2.1.

### 0.3.1 / 2013-09-23

* Always use the system's `stat` command on OSX (@paul).
* Do not assume homebrew is installed at `/usr/local/bin/brew`.
* Properly quote/expand `$CONFIGURE_OPTS` to prevent incorrect word-splitting
  (@pbrisbin).
* Style changes.

#### ruby

* Download from the new http://cache.ruby-lang.org/ CDN (@hsbt).
* When installing ruby 1.8.x, rubygems-2.1.3 will now be installed.
* Added the MD5 checksum for ruby-2.1.0-preview1.tar.bz2.
* Added the `2.1` and `2.1.0` version aliases for 2.1.0-preview1.

#### rubinius

* Support the new 2.x installation process.
* Added MD5s and versions for `2.1.0` and `2.0.0`.
* Removed support for `2.0.0-rc1`.

### 0.3.0 / 2013-07-06

* Added the `-M`,`--mirror` to make it easier to use mirrors.
* The `-p`,`--patch` option will not auto-download patch URLs. (@bkutil)
* The `-v` option was renamed to `-V`. (@havenwood)
* No longer use `sudo` if already running as root. (@zmalltalker)
* Run `brew` as the user that setup homebrew. (@havenwood)

### 0.2.1 / 2013-06-29

* Second argument for `download` may be a directory.
* Second argument for `extract` can be omitted.
* Return an error if no md5 checksum is given to `verify`.
* `extract` now recognizes `.tgz`, `.tbz` and `.tbz2` extensions.
* `apply_patches` now uses `patch -d` to switch to the Ruby source directory
  before applying the patch. Allows `--patch` to be given relative paths.

#### ruby

* Bumped `1.8.7` version to `1.8.7-p374`.
* Bumped `1.9.3` version to `1.9.3-p448`.
* Bumped `2.0.0` version to `2.0.0-p247`.
* Apply the `stdout-rouge-fix.patch` patch to Ruby 1.8.x.
* Install RubyGems into Ruby 1.8.x.

### 0.2.0 / 2013-06-23

* Added support for installing [MagLev]. (@havenwood)
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

[Ruby]: http://www.ruby-lang.org/
[JRuby]: http://jruby.org/
[Rubinius]: http://rubini.us/
[MagLev]: http://maglev.github.io/
