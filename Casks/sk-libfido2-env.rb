cask "sk-libfido2-env" do
    version "10.2p1"
    sha256 "4e2343d853f5bf63bf170ddff3ab8e38e0298931aaec2a4537217289157ed344"

    url "https://raw.githubusercontent.com/haiquand/homebrew-yubikey-ssh/refs/heads/main/script/install-sk-libfido2-env.sh"
    name "sk-libfido2-env"
    desc "Security Key Provider sk-libfido2 LaunchAgent Env for macOS Yubikey for SSH"
    homepage "https://github.com/haiquand/homebrew-yubikey-ssh"

    depends_on formula: "sk-libfido2"

    installer script: {
        executable: "install-sk-libfido2-env.sh",
        sudo: false,
    }

    uninstall launchctl: "com.openssh.sk-libfido2-env"
    
    uninstall_postflight_steps do
        run "/bin/zsh", args: ["-c", "rm ~/Library/LaunchAgents/com.openssh.sk-libfido2-env.plist || true"], sudo: false
        run "/bin/zsh", args: ["-c", "sed -i '' '/export SSH_SK_PROVIDER=/d' ~/.zshrc"], sudo: false
    end

    caveats <<~EOS
        We have updated the SSH_SK_PROVIDER environment variable in your ~/.zshrc file.
        To make it effective immediately, please run:
          source ~/.zshrc
    EOS
end
