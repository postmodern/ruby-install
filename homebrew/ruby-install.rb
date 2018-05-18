class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz"
  sha256 "b3adf199f8cd8f8d4a6176ab605db9ddd8521df8dbb2212f58f7b8273ed85e73"

  head "https://github.com/postmodern/ruby-install.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
