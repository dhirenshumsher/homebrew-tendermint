class Tendermint < Formula
  desc "BFT replicated state machines in any programming language"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.12.1.tar.gz"
  sha256 "cd86033fb256a0b84d86379e2ab71c066fca3c3a07b69c4b4590150a3ea66ac6"

  head do
    url "https://github.com/tendermint/tendermint.git",
      :branch => "develop"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a3e14b9559ad8d491e1d95c091710222cca8a7434aae0510aeb86864226d420e" => :sierra
    sha256 "8dad9e67b061a6c383d03981e612fa3212b1efbd320e73efcac427204512573a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    tendermintpath = buildpath/"src/github.com/tendermint/tendermint"
    tendermintpath.install buildpath.children
    cd tendermintpath do
      system "make", "get_vendor_deps"
      system "make", "build"
      bin.install "build/tendermint"
      prefix.install_metafiles
    end
  end

  test do
    tendermint_version_without_hash = shell_output("#{bin}/tendermint version").partition("-").first
    assert_match version.to_s, tendermint_version_without_hash
  end
end
