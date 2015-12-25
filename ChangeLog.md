### 0.6.0 / 2015-12-24

* Added the `-L`, `--latest` option which downloads versions and checksums from
  [ruby-version].
* Versions and checksums are now auto-downloaded if they are missing.
* Versions and checksums are now stored in `~/.cache/ruby-install/`.

### 0.5.0 / 2014-10-18

* Added the `--prefix` alias for `--install-dir`.
* Added the `--system` alias for `--install-dir /usr/local`.
* Added the `--sha1` option.
* Added the `--sha256` option.
* Added the `--sha512` option.
* Added the `--cleanup` option for deleting the downloaded archive after a
  successful installation.
* Added the `--no-extract` option.
* Switched to using [ruby-versions] for version and checksum information.
  * Adds support for verifying SHA1, SHA256 and SHA512 checksums.
  * All releases of ruby-install will automatically include the latest versions
    and checksums from [ruby-versions].
  * All Pull Requests for new Ruby versions **MUST** be sent to [ruby-versions]!

#### rbx

* Remove duplicate `gem install bundler` command.
* Added `llvm-static` as a yum dependency.

### 0.4.3 / 2014-05-08

#### ruby

* Added 2.1.2.
* Do not explicitly quote the value of `--with-opt-dir`.

#### rbx

* Do not explicitly quote the value of `--with-opt-dir`.

### 0.4.2 / 2014-04-17

#### ruby

* Call `autoreconf` if `configure.in` was patched but `configure` was not.

#### jruby

* Added version 1.7.12.

#### rbx

* Added version 2.2.6.
* Install bundler into `vendor/gems/` to prevent issues when the default
  gemdir is not writable or does not yet exist.

### 0.4.1 / 2014-03-03

* Always clean the source directory before re-building, to prevent linking
  errors after an OS upgrade.

#### functions.sh

* Added the `clean_ruby` function to handle cleaning the source directory.

#### ruby

* Added versions for 2.1.1, 2.0.0-p451 and 1.9.3-p545.
* Removed version aliases for 1.9.1 and 1.9.2.

#### jruby

* Added the 1.7.11 version.
* Copy the compiled ruby instead of moving it.

#### maglev

* Copy the compiled ruby instead of moving it.

#### mruby

* Add support for building with `-j,--jobs`.
* Copy the compiled ruby instead of moving it.

### 0.4.0 / 2014-02-13

* Add support for installing [MRuby] 1.0.0!
* Add the `--rubies-dir` option.
* Add the `--jobs` flag, similar to `make -j4` (@havenwood).
* Support for using the `openssl md5` command (@keiththomps).
* Use the default ANSI foreground colour, for terminals which white backgrounds
  (@cscorley).
* Improved error handling by explicitly returning error codes instead of
  relying on `set -e` (@havenwood).
* Attempt to upgrade previously installed homebrew dependencies.
* Renamed rubinius to rbx for consistency.

#### ruby

* Add version aliases for 1.9.1 and 1.9.2.
* Remove 1.8.x specific workarounds/patches.
* Pass in `--with-opt-dir=/opt/local` when macports is detected.

#### jruby

* Added version for 1.7.10.
* Check for the existence of java, before recommending users install OracleJDK.

#### rbx

* Added versions for 2.2.3, 2.2.4 and 2.2.5.

### 0.3.4 / 2013-12-25

* Use the `.part` file extension for files being downloaded, to distinguish
  between already downloaded files.

#### ruby

* Added versions for 2.1.0-rc1 and 2.1.0.

#### jruby

* Added version for 1.7.9.

#### rubinius

* Added version for 2.2.2.

### 0.3.3 / 2013-12-04

* Add support for the MacPorts package manager (@havenwood).
* Fixed extglob pattern in `fetch`.

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
[MRuby]: https://github.com/mruby/mruby#readme

[ruby-versions]: https://github.com/postmodern/ruby-versions#readme
