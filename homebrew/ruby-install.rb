class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz"
  sha256 "500a8ac84b8f65455958a02bcefd1ed4bfcaeaa2bb97b8f31e61ded5cd0fd70b"

  head "https://github.com/postmodern/ruby-install.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
