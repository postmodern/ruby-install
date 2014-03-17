# ruby-install 1 "Dec 2013" ruby-install "User Manuals"

## SYNOPSIS

`ruby-install` [RUBY [VERSION] [-- CONFIGURE_OPTS...]]

## DESCRIPTION

Installs Ruby, JRuby, Rubinius or MagLev.

https://github.com/postmodern/ruby-install#readme

## ARGUMENTS

*RUBY*
	Install Ruby by name.

*VERSION*
	Optionally select the version of selected Ruby.

*CONFIGURE_OPTS*
	Additional optional configure arguments.

## OPTIONS

`-s`, `--src-dir` *DIR*
	Specifies the directory for downloading and unpacking Ruby source.

`-r`, `--rubies-dir` *DIR*
	Specifies the alternate directory where other Ruby directories are
	installed, such as *~/.rvm/rubies* or *~/.rbenv/versions*.
	Defaults to */opt/rubies* for root and *~/.rubies* for normal users.

`-i`, `--install-dir` *DIR*
	Specifies the directory where Ruby will be installed.
	Defaults to */opt/rubies/$ruby-$version* for root and
	*~/.rubies/$ruby-$version* for normal users.

`-j[`*JOBS*`]`, `--jobs[=`*JOBS*`]`
	Specifies the number of *make* jobs to run in parallel when compiling
	Ruby. If the -j option is provided without an argument, *make* will
	allow an unlimited number of simultaneous jobs.

`-p`, `--patch` *FILE*
	Specifies any additional patches to apply.

`-M`, `--mirror` *URL*
	Specifies an alternate mirror to download the Ruby archive from.

`-u`, `--url` *URL*
	Alternate URL to download the Ruby archive from.

`-m`, `--md5` *MD5*
	Specifies the MD5 checksum for the Ruby archive.

`--no-download`
	Use the previously downloaded Ruby archive.

`--no-verify`
	Do not verify the downloaded Ruby archive.

`--no-install-deps`
	Do not install build dependencies before installing Ruby.

`--no-reinstall`
	Skip installation if another Ruby is detected in same location.

`-V`, `--version`
	Prints the current ruby-install version.

`-h`, `--help`
	Prints a synopsis of ruby-install usage.

## EXAMPLES

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

Install a Ruby from an official site with directly download:

    $ ruby-install -M https://ftp.ruby-lang.org/pub/ruby ruby 2.0.0-p247

Install a Ruby from a mirror:

    $ ruby-install -M http://www.mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby ruby 2.0.0-p247

Install a Ruby with a specific patch:

    $ ruby-install -p https://raw.github.com/gist/4136373/falcon-gc.diff ruby 1.9.3-p429

Install a Ruby with specific configuration:

    $ ruby-install ruby 2.0.0 -- --enable-shared --enable-dtrace CFLAGS="-O3"

Using ruby-install with [RVM]:

    $ ruby-install -i ~/.rvm/rubies/ruby-2.0.0-p247 ruby 2.0.0-p247

Using ruby-install with [rbenv]:

    $ ruby-install -i ~/.rbenv/versions/2.0.0-p247 ruby 2.0.0-p247

## FILES

*/usr/local/src*
	Default root user source directory.
    
*~/src*
	Default non-root user source directory.

*/opt/rubies/$ruby-$version*
	Default root user installation directory.

*~/.rubies/$ruby-$version*
	Default non-root user installation directory.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ruby(1), gem(1), chruby(1), chruby-exec(1)
