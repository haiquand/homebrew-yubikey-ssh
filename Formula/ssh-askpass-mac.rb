class SshAskpassMac < Formula
    desc "A simple SSH Askpass utility for macOS, implemented with SwiftUI."
    homepage "https://github.com/haiquand/ssh-askpass-mac"
    url "https://github.com/haiquand/ssh-askpass-mac/archive/refs/tags/v0.1.0.tar.gz"
    sha256 "cf386b11964c5d71c2a06c9a6a8e2106b6216b7633c411a16acd6c64b2819db3"

    depends_on xcode: :build
    depends_on :macos

    def install
        xcodebuild "-project", "ssh-askpass-mac.xcodeproj",
                    "-scheme", "ssh-askpass-mac",
                    "-arch", Hardware::CPU.arch,
                    "-configuration", "Release",
                    "-derivedDataPath", "./build",
                    "OTHER_SWIFT_FLAGS=-disable-sandbox"
        prefix.install "build/Build/Products/Release/ssh-askpass-mac.app"
        bin.write_exec_script prefix/"ssh-askpass-mac.app/Contents/MacOS/ssh-askpass-mac"
    end

    def caveats
        <<~EOS
        The ssh-askpass-mac.app has been installed to
          #{prefix}/ssh-askpass-mac.app

        A symlink has been created in:
          #{bin}/ssh-askpass-mac
          #{HOMEBREW_PREFIX}/bin/ssh-askpass-mac

        You can set it as your default SSH askpass utility by adding the following line to your shell profile:
        
          export SSH_ASKPASS="$(brew --prefix)/bin/ssh-askpass-mac"
          export SSH_ASKPASS_REQUIRE=force

        Then, when SSH requires a passphrase, a graphical prompt will appear.
        EOS
    end
end