#!/bin/bash
## Gnome 40 ONLY
if has_command apt; then
    sudo apt install -y gnome-tweaks gettext
  elif has_command dnf; then
    sudo dnf install -y gnome-tweaks sassc
  fi
git clone https://github.com/ewlsh/dash-to-dock/
cd dash-to-dock
git checkout ewlsh/gnome-40
git pull
make
sudo make install