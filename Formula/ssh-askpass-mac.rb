class SshAskpassMac < Formula
    desc "A simple SSH Askpass utility for macOS, implemented with SwiftUI."
    homepage "https://github.com/haiquand/ssh-askpass-mac"
    url "https://github.com/haiquand/ssh-askpass-mac/archive/refs/tags/v0.1.0.tar.gz"
    sha256 "cf386b11964c5d71c2a06c9a6a8e2106b6216b7633c411a16acd6c64b2819db3"

    depends_on "xcode" => :build

    def install
        system "make"
        prefix.install "build/Build/Products/Release/ssh-askpass-mac.app"
    end
end