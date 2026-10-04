# homebrew-yubikey-ssh

A Homebrew Tap collection to setup SSH environment.

## sk-libfido2-env

Custom Homebrew tap for installing Yubikey SSH Key(FIDO2) env.

- Auto compile and install the missing macOS Native SSH library `sk-libfido2.dylib` and configure the related `SSH_SK_PROVIDER` environment varibale.

## ssh-askpass-mac

A simple SSH Askpass utility for macOS, implemented with SwiftUI.

- Auto compile and install the `ssh-askpass-mac.app` to Homebrew and create a symlink to `$(brew --prefix)/bin`.

## ssh-askpass-mac-env

LaunchAgent env for the Yubikey style SSH askpass setup.

- Generates a LaunchAgent plist `com.openssh.ssh-env-var.plist` under `~/Library/LaunchAgents` to initialize and persist the `SSH_ASKPASS`, `SSH_ASKPASS_REQUIRE`, `GIT_ASKPASS` and `SSH_AUTH_SOCK` environment variables across user sessions.

- Starts a dedicated `ssh-agent` listening on the `~/.ssh/agent.sock` socket.

## 🔧 Installation

### sk-libfido2-env

```zsh
brew tap haiquand/yubikey-ssh
brew install haiquand/yubikey-ssh/sk-libfido2-env
```

### ssh-askpass-mac

```zsh
brew tap haiquand/yubikey-ssh
brew install haiquand/yubikey-ssh/ssh-askpass-mac
```

### ssh-askpass-mac-env

```zsh
brew tap haiquand/yubikey-ssh
brew install haiquand/yubikey-ssh/ssh-askpass-mac-env
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

### ssh-askpass-mac-env

#### Installation Process

1. Install `haiquand/yubikey-ssh/ssh-askpass-mac` formula, which compiles and installs `ssh-askpass-mac.app` into Homebrew and creates a symlink in `$(brew --prefix)/bin`.

2. Generates a LaunchAgent plist `com.openssh.ssh-env-var.plist` under `~/Library/LaunchAgents` to initialize and persist the SSH askpass environment variables across user sessions.

3. Starts a dedicated `ssh-agent` listening on the `~/.ssh/agent.sock` socket.

The variables are only applied to processes launched by launchd afterwards, so restart your terminal app or log out and back in to pick them up. Note that a shell level `SSH_AUTH_SOCK` export or an `IdentityAgent` entry in `~/.ssh/config` takes precedence over the values set here.

#### Uninstallation Behavior

When uninstalled, the cask automatically performs a cleanup process:

- Unloads and removes the generated LaunchAgent `com.openssh.ssh-env-var.plist` from `~/Library/LaunchAgents`.

- Unsets the `SSH_ASKPASS`, `SSH_ASKPASS_REQUIRE`, `GIT_ASKPASS` and `SSH_AUTH_SOCK` launchctl environment variables.

- Removes the leftover `~/.ssh/agent.sock` socket file.

This ensures no residual configuration remains after the cask is removed.
