class SkLibfido2 < Formula
    desc "Security Key Provider sk-libfido2 for macOS SSH"
    url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.2p1.tar.gz"
    version "10.2p1"
    sha256 "ccc42c0419937959263fa1dbd16dafc18c56b984c03562d2937ce56a60f798b2"

    depends_on "pkgconfig" => :build
    depends_on "libfido2"
    depends_on "openssl@3"

    def install
        system "./configure --with-security-key-standalone"
        system "make"
        lib.install "sk-libfido2.dylib"
    end

    def caveats
        <<~EOS
        The sk-provider library installed in:
          #{lib}
        EOS
    end
end