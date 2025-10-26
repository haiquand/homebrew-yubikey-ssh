cask "sk-libfido2-env" do
    version "10.2p1"
    sha256 "4e2343d853f5bf63bf170ddff3ab8e38e0298931aaec2a4537217289157ed344"

    url "https://raw.githubusercontent.com/haiquand/homebrew-yubikey-ssh/refs/heads/main/script/install-sk-libfido2-env.sh"
    name "sk-libfido2-env"
    desc "Security Key Provider sk-libfido2 LaunchAgent Env for macOS Yubikey for SSH"
    homepage "https://github.com/haiquand/homebrew-yubikey-ssh"

    depends_on formula: "sk-libfido2"

    postflight do
        system_command "/bin/zsh", args: ["#{staged_path}/install-sk-libfido2-env.sh"], sudo: false
        system_command "/bin/zsh", args: ["-c", "/bin/launchctl unload ~/Library/LaunchAgents/com.openssh.sk-libfido2-env.plist &>/dev/null || true"], sudo: false
        system_command "/bin/zsh", args: ["-c", "/bin/launchctl load ~/Library/LaunchAgents/com.openssh.sk-libfido2-env.plist || true"], sudo: false
        system_command "/bin/zsh", args: ["-c", "grep -q \"export SSH_SK_PROVIDER=\" ~/.zshrc && sed -i '' 's|export SSH_SK_PROVIDER=.*|export SSH_SK_PROVIDER=\"$(brew --prefix)/lib/sk-libfido2.dylib\"|' ~/.zshrc || echo 'export SSH_SK_PROVIDER=\"$(brew --prefix)/lib/sk-libfido2.dylib\"' >> ~/.zshrc
"], sudo: false
    end

    uninstall_postflight do
        system_command "/bin/zsh", args: ["-c", "/bin/launchctl unload ~/Library/LaunchAgents/com.openssh.sk-libfido2-env.plist &>/dev/null || true"], sudo: false
        system_command "/bin/zsh", args: ["-c", "rm ~/Library/LaunchAgents/com.openssh.sk-libfido2-env.plist || true"], sudo: false
        system_command "/bin/zsh", args: ["-c", "sed -i '' '/export SSH_SK_PROVIDER=/d' ~/.zshrc"], sudo: false
    end

    caveats <<~EOS
        We have updated the SSH_SK_PROVIDER environment variable in your ~/.zshrc file.
        To make it effective immediately, please run:
          source ~/.zshrc
    EOS
end