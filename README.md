# ruby-install

[![Build Status](https://travis-ci.org/postmodern/ruby-install.png?branch=master)](https://travis-ci.org/postmodern/ruby-install)

Installs [Ruby], [JRuby], [Rubinius] or [MagLev].

## Features

* Supports installing arbitrary versions.
* Supports installing into `/opt/rubies/` for root and `~/.rubies/` for users
  by default.
* Supports installing into arbitrary directories.
* Supports downloading from mirrors.
* Supports downloading/applying patches.
* Supports applying arbitrary patches.
* Supports specifying arbitrary `./configure` options.
* Supports downloading archives using `wget` or `curl`.
* Supports verifying downloaded archives using `md5sum` or `md5`.
* Supports installing build dependencies via the package manager:
  * [apt]
  * [yum]
  * [pacman]
  * [brew]
* Has tests.

## Anti-Features

* Does not require updating every time a new Ruby version comes out.
* Does not require recipes for each individual Ruby version or configuration.

## Requirements

* [bash]
* [wget] or [curl]
* `md5sum` or `md5`
* `tar`

## Synopsis

List supported Rubies and their major versions:

    $ ruby-install

Install the current stable version of Ruby:

    $ ruby-install ruby

Install a latest version of Ruby:

    $ ruby-install ruby 1.9

Install a specific version of Ruby:

    $ ruby-install ruby 1.9.3-p429

Install a Ruby into a specific directory:

    $ ruby-install -i /usr/local/ ruby 1.9.3-p429

Install a Ruby from a official site with directly download:

    $ ruby-install -M https://ftp.ruby-lang.org/pub/ruby ruby 2.0.0-p247

Install a Ruby from a mirror:

    $ ruby-install -M http://www.mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby ruby 2.0.0-p247

Install a Ruby with a specific patch:

    $ ruby-install -p https://raw.github.com/gist/4136373/falcon-gc.diff ruby 1.9.3-p429

Install a Ruby with specific configuration:

    $ ruby-install ruby 2.0.0 -- --enable-shared --enable-dtrace CFLAGS="-O3"

### Integration

Using ruby-install with [RVM]:

    $ ruby-install -i ~/.rvm/rubies/ruby-2.0.0-p247 ruby 2.0.0-p247

Using ruby-install with [rbenv]:

    $ ruby-install -i ~/.rbenv/versions/2.0.0-p247 ruby 2.0.0-p247

## Install

    wget -O ruby-install-0.3.2.tar.gz https://github.com/postmodern/ruby-install/archive/v0.3.2.tar.gz
    tar -xzvf ruby-install-0.3.2.tar.gz
    cd ruby-install-0.3.2/
    sudo make install

### PGP

All releases are [PGP] signed for security. Instructions on how to import my
PGP key can be found on my [blog][1]. To verify that a release was not tampered 
with:

    wget https://raw.github.com/postmodern/ruby-install/master/pkg/ruby-install-0.3.2.tar.gz.asc
    gpg --verify ruby-install-0.3.2.tar.gz.asc ruby-install-0.3.2.tar.gz

### Homebrew

ruby-install can also be installed with [homebrew]:

    brew install ruby-install

## Alternatives

* [RVM]
* [ruby-build]

## Endorsements

> I like the approach you're taking. Curious to see how it plays out.

-- [Sam Stephenson](https://twitter.com/sstephenson/status/334461494668443649)
of [rbenv]

[Ruby]: http://www.ruby-lang.org/
[JRuby]: http://jruby.org/
[Rubinius]: http://rubini.us/
[MagLev]: http://maglev.github.io/

[apt]: http://wiki.debian.org/Apt
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[brew]: http://mxcl.github.com/homebrew/

[bash]: http://www.gnu.org/software/bash/
[wget]: http://www.gnu.org/software/wget/
[curl]: http://curl.haxx.se/

[RVM]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv#readme
[ruby-build]: https://github.com/sstephenson/ruby-build#readme

[PGP]: http://en.wikipedia.org/wiki/Pretty_Good_Privacy
[1]: http://postmodern.github.com/contact.html#pgp

[homebrew]: http://mxcl.github.com/homebrew/
