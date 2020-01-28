#!/bin/sh

python -mplatform | grep -qi Ubuntu && gsettings set org.gnome.desktop.background show-desktop-icons false
mkdir ~/.i3
ln -fs $(pwd)/configFr ~/.i3/configFr
ln -fs $(pwd)/configUs ~/.i3/configUs
ln -fs $(pwd)/configUs ~/.i3/config
sudo apt-get install rxvt-unicode zsh feh i3blocks fonts-font-awesome xsel nano i3 curl git compton
ln -fs $(pwd)/i3status.conf ~/.i3status.conf
ln -fs $(pwd)/.Xresources ~/.Xressources
ln -fs $(pwd)/i3blocks ~/.config/i3blocks
sudo apt-get install rxvt-unicode
sudo ln -fs $(pwd)/xorg.conf.new /etc/X11/xorg.conf
#sudo apt install dbus lua-lgi lua-posix lua5.1 luajit qemu qemu-user-static htop meld pavucontrol automake screen microcom u-boot-tools device-tree-compiler iperf chromium-browser kdeconnect nmap
#sudo apt install qemu-user-static


# wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
# echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
#  sudo apt update && sudo apt install sublime-text


# sudo apt install autojump
# echo ". /usr/share/autojump/autojump.sh" >> ~/.zshrc

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#sudo usermod -a -G dialout ${USER}
#sudo usermod -a -G docker ${USER}

