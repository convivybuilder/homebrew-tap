# Convivy Builder for Homebrew

This tap installs the installer for [Convivy Builder](https://convivybuilder.org):

```
brew install convivybuilder/tap/builder
builder-install
```

`builder-install` is the same script the site serves at https://convivybuilder.org/install.sh. The
formula pins one Builder release by the checksum of its source archive, and `brew upgrade` moves you
to a newer release when this tap publishes one.

Builder's source is at https://github.com/convivybuilder/shipwright.
