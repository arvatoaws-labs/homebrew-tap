class SfnNg < Formula
  desc "Arvato SFN-NG"
  homepage "https://github.com/arvatoaws-labs/sfn-ng"
  url "https://github.com/arvatoaws-labs/sfn-ng/archive/v0.2.21.tar.gz"
  sha256 "5c354ac0602b2f8bdef80e416e0429a345f126f7ad64f7e138347a419e2545f"
  license "GPL-3.0"

  # livecheck do
  #   url :stable
  #   strategy :github_latest
  # end

  # bottle do
  #   sha256 cellar: :any, arm64_big_sur: "e0147ba489a8d96e33fc8be7e2172c632075d5d31a4f6267c3606e463280e0e3"
  #   sha256 cellar: :any, big_sur:       "0ca7397f9a0ccef6cbb8ff0fd8fb18c6fe86219abaef350e3d7ef248d07440fd"
  #   sha256 cellar: :any, catalina:      "60460d422253113af3ed60332104f309638942821c655332211a6bc2213c472c"
  #   sha256 cellar: :any, mojave:        "de4b18789f5d9bc4aaa4d906501200ae4ece7a1971dd1b86e2b2d0a2c8e0d764"
  #   sha256 cellar: :any, high_sierra:   "cfea5335bf4eccfb7cd1d93bec234d96bd49dce8d593ea966687f777909ba291"
  # end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # out_dir = Dir["target/release/build/sfn-ng-*/out"].first
    # zsh_completion.install "complete/_sfn-ng"
  end

  test do
    assert_match "sfn-ng", shell_output("#{bin}/sfn-ng --version")
  end
end
