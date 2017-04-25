#!/bin/sh


python -mplatform | grep -qi Ubuntu && gsettings set org.gnome.desktop.background show-desktop-icons false
mkdir ~/.i3
cp configFr ~/.i3/
cp workspaceFirmware.json ~/.i3/
cp workspaceDashboard2.json ~/.i3/
sudo apt-get install rxvt-unicode zsh
cp i3status.conf ~/.i3status.conf
cp .Xresources ~/
sudo apt-get install rxvt-unicode


