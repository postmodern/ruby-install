require 'formula'

class RubyInstall < Formula
  homepage 'https://github.com/postmodern/ruby-install#readme'
  url 'https://github.com/postmodern/ruby-install/archive/v0.1.2.tar.gz'
  sha1 'bc1906085f94da5a54e804b6d7aea0f2c0fdd088'

  head 'https://github.com/postmodern/ruby-install.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
