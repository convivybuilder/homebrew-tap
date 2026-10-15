class Builder < Formula
  desc "Build software with a crew of AI agents"
  homepage "https://convivybuilder.org"
  url "https://github.com/convivybuilder/shipwright/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "3063d5077c5862b918b2ed3634a042a02a5d7b4eada2ec583af5e83a7b9ece9c"
  license "Apache-2.0"

  depends_on "python@3.11"
  depends_on "tmux"

  def install
    # The same rewrite the site makes to the copy it serves at /install.sh, so
    # this copy installs the release this formula pins and no other.
    inreplace "bin/builder-install", 'BAKED_RELEASE="@RELEASE@"', "BAKED_RELEASE=\"#{version}\""
    bin.install "bin/builder-install"
  end

  def caveats
    <<~EOS
      Homebrew has installed only the installer. To install Builder, run:
        builder-install
      On the laptop you work from, run:
        builder-install --role laptop
    EOS
  end

  test do
    assert_match "BAKED_RELEASE=\"#{version}\"", (bin/"builder-install").read
    assert_match "usage: builder-install", shell_output("#{bin}/builder-install --help 2>&1")
  end
end
