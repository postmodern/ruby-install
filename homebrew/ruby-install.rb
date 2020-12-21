class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.1.tar.gz"
  sha256 "d96fce7a4df70ca7a367400fbe035ff5b518408fc55924966743abf66ead7771"
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
