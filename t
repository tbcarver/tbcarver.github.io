#!/bin/sh
# turbo bootstrap: run as root. Temporary, removed once turbo is on Tailscale.
set -e
# A DVD/USB install leaves a cdrom source that makes apt fail; drop it and add the network mirror.
sed -i '/cdrom/d' /etc/apt/sources.list 2>/dev/null || true
if ! grep -rqs '^[^#]*http' /etc/apt/sources.list /etc/apt/sources.list.d/; then
  cat > /etc/apt/sources.list <<'SRC'
deb http://deb.debian.org/debian trixie main
deb http://deb.debian.org/debian trixie-updates main
deb http://security.debian.org/debian-security trixie-security main
SRC
fi
apt-get update
apt-get install -y sudo curl ssh-import-id openssh-server
echo 'tyler ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tyler
chmod 440 /etc/sudoers.d/tyler
su - tyler -c 'ssh-import-id gh:tbcarver'
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --hostname=turbo --operator=tyler
echo "turbo bootstrap done"
