# ruby-install 1 "May 2013" ruby-install "User Manuals"

## SYNOPSIS

`ruby-install` [RUBY [VERSION]] [-- CONFIGURE_OPTS...]

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

`-i`, `--install-dir` *DIR*
	Specifies the dirctory where Ruby will be installed.

`-p`, `--patch` *FILE*
	Specifies any additional patches to apply.

`-m`, `--md5` *MD5*
	Specifies the MD5 checksum for the Ruby archive.

`--skip-install-deps`
	Do not install build dependencies before installing Ruby.

`--no-reinstall`
	Skip installation if another Ruby is detected in same location.

`-v`, `--version`
	Prints the current ruby-install version.

`-h`, `--help`
	Prints a synopsis of ruby-install usage.

## EXAMPLES

Install the current stable version of Ruby:

    $ ruby-install ruby

Install a specific version of Ruby:

    $ ruby-install ruby 1.9.3-p395

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
