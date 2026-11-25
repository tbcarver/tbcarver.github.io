#!/bin/sh
# turbo bootstrap: run as root. Temporary, removed once turbo is on Tailscale.
set -e
apt-get update
apt-get install -y sudo curl ssh-import-id openssh-server
echo 'tyler ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tyler
chmod 440 /etc/sudoers.d/tyler
su - tyler -c 'ssh-import-id gh:tbcarver'
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --hostname=turbo --operator=tyler
