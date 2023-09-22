#!/bin/sh -eu

current_dir="$(basename $PWD)"

if [ $current_dir != "configWorkspace" ]; then
  echo wrong dir
  exit 2
fi

python3 -mplatform | grep -qi Ubuntu && gsettings set org.gnome.desktop.background show-desktop-icons false
mkdir ~/.i3
ln -fs "$(pwd)/configUs" ~/.i3/config
ln -fs "$(pwd)/i3status.conf" ~/.i3status.conf
ln -fs "$(pwd)/.Xresources" ~/.Xressources
ln -fs "$(pwd)/i3blocks" ~/.config/i3blocks

sudo apt-get update

sudo apt-get install rxvt-unicode zsh feh i3blocks fonts-font-awesome xsel nano i3 curl git compton unzip playerctl autorandr lm-sensors tig

# Usefull for laptop
#sudo ln -fs "$(pwd)/xorg.conf.new" /etc/X11/xorg.conf

# Required for Appimage
sudo apt install libfuse2

sudo apt install wine

# Hue control
# sudo apt install npm
# sudo npm install -g hueadm


sudo mkdir -p /usr/lib/urxvt/perl
sudo cp "$(pwd)/scripts/resize-font" /usr/lib/urxvt/perl

if command -v nautilus; then
	cp "$(pwd)/user-dirs.dirs" ~/.config/user-dirs.dirs
	sudo cp "$(pwd)/user-dirs.defaults" /etc/xdg/user-dirs.defaults
fi

echo "Installing JetBrainsMono-1 font"
if wget https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip; then
	if unzip JetBrainsMono-1.0.3.zip; then
		sudo mv JetBrainsMono-1.0.3 /usr/share/fonts/
	fi
	rm JetBrainsMono-1.0.3.zip
	printf "\rFor subl: preferences/settings\n"
	printf '\r\r "font_face": "JetBrains Mono Regular", \n'
	xrdb -load ~/.Xressources
	i3-msg "reload"
fi

echo 'DISABLE_UPDATE_PROMPT="true"' >> ~/.zshrc
echo 'export UPDATE_ZSH_DAYS=31' >> ~/.zshrc


# Development related
#sudo apt install dbus lua-lgi lua-posix lua5.1 luajit qemu qemu-user-static automake screen microcom u-boot-tools device-tree-compiler iperf
#sudo apt install qemu-user-static

# Canonical
#sudo apt install python3-launchpadlib python3-jira python3-pandas bash-completion build-essential ccache debhelper devscripts docbook-utils fakeroot gawk git git-email kernel-wedge libncurses5-dev makedumpfile schroot sharutils snapcraft transfig ubuntu-dev-tools wget xmlto

# Utilities
#sudo apt install picocom thunderbird kdeconnect nmap meld htop screen vlc pavucontrol chromium-browser p7zip-full redshift tig vorta

# Sublime text
# wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
# echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
#  sudo apt update && sudo apt install sublime-text


# sudo apt install autojump
# echo ". /usr/share/autojump/autojump.sh" >> ~/.zshrc

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#sudo usermod -a -G dialout ${USER}
#sudo usermod -a -G docker ${USER}
