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
    # The release check needs the release keys, and Homebrew installs this one
    # file, so it cannot find the archive's release-signers beside it. Bake the
    # archive's own copy in, the way the site does for /install.sh, as a shell
    # single-quoted literal with each ' written '\''. The archive is the one
    # this formula's sha256 pins, so the trust list comes with it. The block
    # forms of gsub and sub keep Ruby from reading \' as a backreference.
    signers = File.read("release-signers")
    quoted = "'" + signers.gsub("'") { "'\\''" } + "'"
    placeholder = "BAKED_RELEASE_SIGNERS='@RELEASE_SIGNERS@'"
    script = File.read("bin/builder-install")
    odie "bin/builder-install has no #{placeholder} line to bake the release keys into" unless script.include?(placeholder)
    File.write("bin/builder-install", script.sub(placeholder) { "BAKED_RELEASE_SIGNERS=#{quoted}" })
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
    # The whole assignment, since the script's own check compares against the bare placeholder.
    refute_match "BAKED_RELEASE_SIGNERS='@RELEASE_SIGNERS@'", (bin/"builder-install").read
    system "/bin/sh", "-n", bin/"builder-install"
    assert_match "usage: builder-install", shell_output("#{bin}/builder-install --help 2>&1")
  end
end
