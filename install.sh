#!/bin/sh

python -mplatform | grep -qi Ubuntu && gsettings set org.gnome.desktop.background show-desktop-icons false
mkdir ~/.i3
ln -s configFr ~/.i3/configFr
ln -s configUs ~/.i3/configUs
ln -s configUs ~/.i3/config
sudo apt-get install rxvt-unicode zsh feh i3blocks fonts-font-awesome xsel nano
ln -s i3status.conf ~/.i3status.conf
ln -s .Xresources ~/.Xressources
ln -s i3blocks ~/.config/i3blocks
sudo apt-get install rxvt-unicode


