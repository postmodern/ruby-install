class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.3.tar.gz"
  sha256 "e2f69949757d032d48ee5c028be020bdc8863c41d5648b53328903d2e16ab3b2"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90078fb4aefc71c0790721c0b4e62c6cbc933f702f42b723c2ef5869cd5f9227" => :high_sierra
    sha256 "a9e4545b46128f0d35e25c7e558330a93a8ceaf025410610c795b9904bf241a1" => :sierra
    sha256 "3b0b594e01f951b7161b36b33ae59fd0063ac05212708e6eb107bf70fd508258" => :el_capitan
    sha256 "3b0b594e01f951b7161b36b33ae59fd0063ac05212708e6eb107bf70fd508258" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
