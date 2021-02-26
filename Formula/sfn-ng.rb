class SfnNg < Formula
  desc "Arvato SFN-NG"
  homepage "https://github.com/arvatoaws-labs/sfn-ng"
  url "https://github.com/arvatoaws-labs/sfn-ng/archive/v0.2.17.tar.gz"
  sha256 "80ef53862bb3953e4ca647c2cff39ae7f0b2f9ed7e88397cea3d67cb9022df7d"
  license "GPL-3.0"

  def install
    bin.install "sfn-ng"
  end

  test do
    assert_match "sfn-ng", shell_output("#{bin}/sfn-ng --version")
  end
end
