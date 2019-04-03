#!/bin/sh

sudo apt-get install zsh feh xsel nano docker docker-compose git htop screen
sudo apt install fail2ban
chsh -s /bin/zsh tibx

##Secure ssh
#sudo nano /etc/ssh/sshd_config
#sudo systemctl reload sshd
#sudo apt install ufw fail2ban
#sudo nano /etc/fail2ban/jail.d/custom.conf
#sudo systemctl restart fail2ban
#sudo fail2ban-client status
