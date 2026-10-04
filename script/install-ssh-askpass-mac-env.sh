#!/bin/bash

if [[ "$(uname -m)" == "x86_64" ]]; then
  homebrew_prefix=/usr/local
elif [[ "$(uname -m)" == "arm64" ]]; then
  homebrew_prefix=/opt/homebrew
fi

plist_name=com.openssh.ssh-env-var

ssh_agent=$homebrew_prefix/bin/ssh-agent
ssh_askpass=$homebrew_prefix/bin/ssh-askpass-mac
ssh_auth_sock=$HOME/.ssh/agent.sock
ssh_agent_debug_log=$HOME/.ssh/ssh-agent-debug.log

plist_target_file=$HOME/Library/LaunchAgents/$plist_name.plist

if [ ! -x "$ssh_askpass" ]; then
    echo "ssh-askpass-mac $ssh_askpass not found!"
    exit 1
fi

if [ ! -x "$ssh_agent" ]; then
    echo "ssh-agent $ssh_agent not found!"
    exit 1
fi

# Unload the existing LaunchAgent, ignoring errors when it is not loaded yet
/bin/launchctl bootout "gui/$(id -u)/$plist_name" >/dev/null 2>&1 || true
/bin/launchctl unload "$plist_target_file" >/dev/null 2>&1 || true

cat <<EOF | tee $plist_target_file
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$plist_name</string>

    <key>EnvironmentVariables</key>
    <dict>
        <key>SSH_ASKPASS</key>
        <string>$ssh_askpass</string>
        <key>SSH_ASKPASS_REQUIRE</key>
        <string>force</string>
        <key>GIT_ASKPASS</key>
        <string>$ssh_askpass</string>
    </dict>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>-c</string>
        <string>/bin/launchctl setenv SSH_AUTH_SOCK "$ssh_auth_sock"
/bin/launchctl setenv SSH_ASKPASS "$ssh_askpass"
/bin/launchctl setenv SSH_ASKPASS_REQUIRE "force"
/bin/launchctl setenv GIT_ASKPASS "$ssh_askpass"
$ssh_agent -a $ssh_auth_sock -D</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <!--
    <key>StandardErrorPath</key>
    <string>$ssh_agent_debug_log</string>
    <key>StandardOutPath</key>
    <string>$ssh_agent_debug_log</string>
    -->
</dict>
</plist>
EOF

plutil -lint "$plist_target_file" || exit 1

# Load the LaunchAgent (bootstrap is the modern replacement for the deprecated load)
/bin/launchctl bootstrap "gui/$(id -u)" "$plist_target_file" >/dev/null 2>&1 \
    || /bin/launchctl load "$plist_target_file" >/dev/null 2>&1 \
    || true

if /bin/launchctl print "gui/$(id -u)/$plist_name" >/dev/null 2>&1; then
    echo "LaunchAgent $plist_name loaded. Restart your terminal app to pick up the environment."
else
    echo "Warning: could not load $plist_name into the GUI session." >&2
    echo "Run this in a logged-in terminal: launchctl load $plist_target_file" >&2
    exit 1
fi
