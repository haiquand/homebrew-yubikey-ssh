cask "sk-libfido2-env" do
    version "10.2p3"
    sha256 "9db44cdcac38a886c60ed4538be68db003b9cc8053c30c75a35b730e566aa348"

    url "https://raw.githubusercontent.com/haiquand/homebrew-yubikey-ssh/refs/heads/main/script/install-sk-libfido2-env.sh"
    name "sk-libfido2-env"
    desc "Security Key Provider sk-libfido2 LaunchAgent Env for macOS Yubikey for SSH"
    homepage "https://github.com/haiquand/homebrew-yubikey-ssh"

    depends_on formula: "sk-libfido2"

    generated_script 'uninstall-sk-libfido2-env.sh', content: <<~'SH'
        #!/bin/bash
        set -u
        /bin/launchctl unsetenv SSH_SK_PROVIDER 2>/dev/null || true
        zshrc="$HOME/.zshrc"
        [ -f "$zshrc" ] || exit 0
        sed -i '' '/export SSH_SK_PROVIDER=/d' "$zshrc"
    SH

    installer script: {
        executable: "install-sk-libfido2-env.sh",
        sudo: false,
    }

    uninstall launchctl: "com.openssh.sk-libfido2-env",
              script: { executable: "uninstall-sk-libfido2-env.sh", sudo: false }

    caveats <<~EOS
        We have updated the SSH_SK_PROVIDER environment variable in your ~/.zshrc file.
        To make it effective immediately, please run:
          source ~/.zshrc
    EOS
end
