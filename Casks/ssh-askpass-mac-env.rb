cask "ssh-askpass-mac-env" do
    version "0.1.0"
    sha256 "0f16be7c38894c013988de6a03e5cdc8bb674f046ad589f8cfd411d32bb11e6d"

    url "https://raw.githubusercontent.com/haiquand/homebrew-yubikey-ssh/refs/heads/main/script/install-ssh-askpass-mac-env.sh"
    name "ssh-askpass-mac-env"
    desc "SSH Askpass and ssh-agent LaunchAgent Env for macOS"
    homepage "https://github.com/haiquand/homebrew-yubikey-ssh"

    depends_on formula: "ssh-askpass-mac"

    generated_script 'uninstall-ssh-askpass-mac-env.sh', content: <<~'SH'
        #!/bin/bash
        set -u
        plist_name=com.openssh.ssh-env-var
        plist_target_file="$HOME/Library/LaunchAgents/$plist_name.plist"

        /bin/launchctl bootout "gui/$(id -u)/$plist_name" 2>/dev/null || true
        /bin/launchctl unload "$plist_target_file" 2>/dev/null || true
        rm -f "$plist_target_file"

        /bin/launchctl unsetenv SSH_ASKPASS 2>/dev/null || true
        /bin/launchctl unsetenv SSH_ASKPASS_REQUIRE 2>/dev/null || true
        /bin/launchctl unsetenv GIT_ASKPASS 2>/dev/null || true
        /bin/launchctl unsetenv SSH_AUTH_SOCK 2>/dev/null || true

        rm -f "$HOME/.ssh/agent.sock"
    SH

    installer script: {
        executable: "install-ssh-askpass-mac-env.sh",
        sudo: false,
    }

    uninstall launchctl: "com.openssh.ssh-env-var",
              script: { executable: "uninstall-ssh-askpass-mac-env.sh", sudo: false }

    caveats <<~EOS
        A LaunchAgent has been installed to initialize the Yubikey style SSH askpass environment:

          SSH_ASKPASS, GIT_ASKPASS  -> #{HOMEBREW_PREFIX}/bin/ssh-askpass-mac
          SSH_AUTH_SOCK             -> ~/.ssh/agent.sock (served by #{HOMEBREW_PREFIX}/bin/ssh-agent)

        The variables are applied to processes launched by launchd afterwards, so restart
        your terminal app (or log out and back in) for them to take effect.

        Note that a shell level SSH_AUTH_SOCK export or an IdentityAgent entry in
        ~/.ssh/config takes precedence over the values set here.
    EOS
end
