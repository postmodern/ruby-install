# ruby-install

Installs Ruby, JRuby or Rubinius.

## Features

* Allows installing arbitrary versions.
* Allows installing into arbitrary directories.
* Allows apply arbitrary patches.
* Allows specifying arbitrary `./configure` options.
* Automatically installs dependencies via the package manager.
* Auto-detects the package manager:
  * [apt]
  * [yum]
  * [brew]

## Anti-Features

* Does not require updating every time a new Ruby version comes out.
* Does not require recipes for each individual Ruby version or configuration.

## Requirements

* [bash]

## Examples

Install the current stable version of Ruby:

    $ ruby-install ruby

Install a specific version of Ruby:

    $ ruby-install ruby 1.9.3-p395

## Alternatives

* [RVM]
* [ruby-build]

[apt]: http://wiki.debian.org/Apt
[yum]: http://yum.baseurl.org/
[brew]: http://mxcl.github.com/homebrew/

[bash]: http://www.gnu.org/software/bash/

[RVM]: https://rvm.io/
[ruby-build]: https://github.com/sstephenson/ruby-build#readme
