# ruby-install

Installs Ruby, JRuby or Rubinius.

## Features

* Allows installing arbitrary versions.
* Allows installing into arbitrary directories.
* Allows apply arbitrary patches.
* Allows specifying arbitrary `./configure` options.
* Automatically installs dependencies via the package manager.
* Supports `md5sum` and `md5`.
* Supports `wget` and `curl`.
* Supports multiple package managers:
  * [apt]
  * [yum]
  * [pacman]
  * [brew]

## Anti-Features

* Does not require updating every time a new Ruby version comes out.
* Does not require recipes for each individual Ruby version or configuration.

## Requirements

* [bash]

## Synopsis

Install the current stable version of Ruby:

    $ ruby-install ruby

Install a specific version of Ruby:

    $ ruby-install ruby 1.9.3-p395

Install a Ruby into a specific directory:

    $ ruby-install -i /opt/rubies/ruby-1.9.3-p395 ruby 1.9.3-p395

Install a Ruby with a specific patch:

    $ ruby-install -p https://raw.github.com/gist/4136373/falcon-gc.diff ruby 1.9.3-p395

Install a Ruby with specific configuration:

    $ ruby-install ruby 2.0.0 -- --enable-shared --enable-dtrace

## Alternatives

* [RVM]
* [ruby-build]

[apt]: http://wiki.debian.org/Apt
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[brew]: http://mxcl.github.com/homebrew/

[bash]: http://www.gnu.org/software/bash/

[RVM]: https://rvm.io/
[ruby-build]: https://github.com/sstephenson/ruby-build#readme
