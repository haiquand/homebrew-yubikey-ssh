
if [[ "$(uname -m)" == "x86_64" ]]; then
  homebrew_prefix=/usr/local
elif [[ "$(uname -m)" == "arm64" ]]; then
  homebrew_prefix=/opt/homebrew
fi

plist_name=com.openssh.sk-libfido2-env

ssh_sk_provider=$homebrew_prefix/lib/sk-libfido2.dylib

plist_target_file=$HOME/Library/LaunchAgents/$plist_name.plist

if [ ! -f "$ssh_sk_provider" ]; then
    echo "Security Key Provider sk-libfido2 $ssh_sk_provider not found!"
    exit 1;
fi

cat <<EOF | tee $plist_target_file
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$plist_name</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>-c</string>
        <string>/bin/launchctl setenv SSH_SK_PROVIDER "$ssh_sk_provider"</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF