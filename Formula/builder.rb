class Builder < Formula
  desc "Build software with a crew of AI agents"
  homepage "https://convivybuilder.org"
  url "https://github.com/convivybuilder/shipwright/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cac2bfc936b4dd812ad61991647274d307cf705bab3fd54cdbead34bced9433a"
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
