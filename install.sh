#!/bin/sh

python -mplatform | grep -qi Ubuntu && gsettings set org.gnome.desktop.background show-desktop-icons false
mkdir ~/.i3
ln -fs $(pwd)/configFr ~/.i3/configFr
ln -fs $(pwd)/configUs ~/.i3/configUs
ln -fs $(pwd)/configUs ~/.i3/config
sudo apt-get install rxvt-unicode zsh feh i3blocks fonts-font-awesome xsel nano i3 curl git
ln -fs $(pwd)/i3status.conf ~/.i3status.conf
ln -fs $(pwd)/.Xresources ~/.Xressources
ln -fs $(pwd)/i3blocks ~/.config/i3blocks
sudo apt-get install rxvt-unicode


