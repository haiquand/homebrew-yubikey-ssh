# homebrew-yubikey-ssh

A Homebrew Tap collection to setup SSH environment.

## sk-libfido2-env

Custom Homebrew tap for installing Yubikey SSH Key(FIDO2) env.

- Auto compile and install the missing macOS Native SSH library `sk-libfido2.dylib` and configure the related `SSH_SK_PROVIDER` environment varibale.

## ssh-askpass-mac

A simple SSH Askpass utility for macOS, implemented with SwiftUI.

- Auto compile and install the `ssh-askpass-mac.app` to Homebrew and create a symlink to `$(brew --prefix)/bin`.

## 🔧 Installation

### sk-libfido2-env

```zsh
brew tap haiquand/yubikey-ssh
brew install haiquand/yubikey-ssh/sk-libfido2-env
```

### ssh-askpass-mac

```zsh
brew tap haiquand/yubikey-ssh
brew install haiquand/yubikey-ssh/ssk-askpass-mac
```

## 🧠 System Integration Details

For advanced users or developers, the following section describes what happens behind the scenes during installation and removal.

### sk-libfido2-env

#### Installation Process

1. Install `haiquand/yubikey-ssh/sk-libfido2` formula, which compile and install the `sk-libfido2.dylib` into Homebrew `lib` directory (`$(brew --prefix)/lib`).

2. Generates a LaunchAgent plist `com.openssh.sk-libfido2-env.plist` under `~/Library/LaunchAgents` to initialize and persist the `SSH_SK_PROVIDER` environment variable across user sessions.

3. Appends or updates the `SSH_SK_PROVIDER` variable in your shell initialization file (`~/.zshrc`), ensuring it is available in interactive shells without requiring manual configuration.

#### Uninstallation Behavior

When uninstalled, the cask automatically performs a cleanup process:

- Removes the generated LaunchAgent `com.openssh.sk-libfido2-env.plist` from `~/Library/LaunchAgents`.

- Deletes the corresponding `SSH_SK_PROVIDER` export line from your `~/.zshrc` file.

This ensures no residual configuration remains after the cask is removed.


### ssh-askpass-mac

1. Download the Release Source Code of [haiquand/ssh-askpass-mac](https://github.com/haiquand/ssh-askpass-mac) project.

2. Use `xcodebuild` the build the project.

3. Install to homebrew and create a symlink to `$(brew --prefix)/bin`.
