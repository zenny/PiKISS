#!/bin/bash
#
# Description : Install Printer Server (cups)
# Author      : Jose Cerrejon Gonzalez (ulysess@gmail_dot._com)
# Version     : 0.7 (26/May/14)
#
# TODO        · Test again. I think allow_remote_machine is incorrect
#
# IMPROVEMENT · Uninstall option if cups is detected
#
clear

USER=$(whoami)
IP="localhost"
# Fuck·$% next line... 2 hours to get it work >:(
IP_MASK=$(echo $(hostname -I)|cut -f1-3 -d"."|awk '{print $1".*"}')

allow_remote_machines(){
    $IP=$(hostname -I)
    sudo cp /etc/cups/cupsd.conf{,.bak}
    sudo sed -i '/Listen localhost:631/s/^/#/' /etc/cups/cupsd.conf
    sudo sed -i 's/.*Listen localhost:631.*/&\nListen *:631/' /etc/cups/cupsd.conf
    sudo sed -e 's/.*    Order deny,allow.*/&\n    Allow '$IP_MASK'/' /etc/cups/cupsd.conf
    sudo service cups restart
}

echo -e "Installing cups (64.8 MB aprox.)\n================================\n"
sudo apt-get install cups
sudo usermod -a -G lpadmin $USER

read -p "Do you want to allow server admin from remote machines (y/n)?" option
case "$option" in
    y*) allow_remote_machines ;;
esac

read -p "Done!. Now you can browser to http://$IP:631 Press [Enter] to continue..."