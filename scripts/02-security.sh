#!/bin/sh

# start fail2ban
# https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-20-04
systemctl enable fail2ban
systemctl start fail2ban

# open ports
# https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands
ufw limit ssh
ufw allow http
ufw allow https

ufw --force enable
