#!/bin/bash
sudo dnf install -y gnome-tweaks sassc
git clone https://github.com/ewlsh/dash-to-dock/
cd dash-to-dock
git checkout ewlsh/gnome-40
git pull
make
sudo make install