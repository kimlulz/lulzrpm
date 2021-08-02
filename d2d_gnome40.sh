#!/bin/bash
sudo dnf install -y gnome-tweaks sassc flatpak
git clone https://github.com/ewlsh/dash-to-dock/
cd dash-to-dock
git checkout ewlsh/gnome-40
git pull
make
sudo make install
wget https://dl.flathub.org/repo/appstream/org.gnome.Extensions.flatpakref
sudo flatpak install -y org.gnome.Extensions.flatpakref