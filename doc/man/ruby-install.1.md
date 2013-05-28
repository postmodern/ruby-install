# ruby-install 1 "May 2013" ruby-install "User Manuals"

## SYNOPSIS

`ruby-install` [RUBY [VERSION]] [-- CONFIGURE_OPTS...]

## DESCRIPTION

Installs Ruby, JRuby or Rubinius.

https://github.com/postmodern/ruby-install#readme

## ARGUMENTS

*RUBY*
	Install Ruby by name.

*VERSION*
	Optionally select the version of selected Ruby.

*CONFIGURE_OPTS*
	Additional optional configure arguements.

## OPTIONS

`-s`, `--src-dir` *DIR*
	Specifies the directory for downloading and unpacking Ruby source.

`-i`, `--install-dir` *DIR*
	Specifies the dirctory where Ruby will be installed.

`-p`, `--patch` *FILE*
	Specifies any additional patches to apply.

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
