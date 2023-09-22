#!/bin/sh

sudo apt-get install zsh feh nano docker docker-compose git htop screen
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

##Secure ssh
#sudo nano /etc/ssh/sshd_config
#sudo systemctl reload sshd
#sudo apt install ufw fail2ban
#sudo nano /etc/fail2ban/jail.d/custom.conf
#sudo systemctl restart fail2ban
#sudo fail2ban-client status
