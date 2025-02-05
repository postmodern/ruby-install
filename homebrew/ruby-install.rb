class RubyInstall < Formula
  desc "Install Ruby, JRuby, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/releases/download/v0.10.0/ruby-install-0.10.0.tar.gz"
  sha256 "8aee2224b33d661a7db777b094adb10390b8962ff9b5a76765dd4f3e9ef16176"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d19d4a89f08d447d522387e362b5e4627de5438e06396e2035fe735dc192d7de"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd1ffd6780ab70d0701e812784ed7a7bb2276c6fc8f3303570fbf200a4f2ccde"
    sha256 cellar: :any_skip_relocation, catalina:      "cd1ffd6780ab70d0701e812784ed7a7bb2276c6fc8f3303570fbf200a4f2ccde"
    sha256 cellar: :any_skip_relocation, mojave:        "cd1ffd6780ab70d0701e812784ed7a7bb2276c6fc8f3303570fbf200a4f2ccde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19d4a89f08d447d522387e362b5e4627de5438e06396e2035fe735dc192d7de"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
