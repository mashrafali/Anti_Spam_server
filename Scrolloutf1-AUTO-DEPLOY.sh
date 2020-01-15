#! /bin/bash

clear
echo
echo "                                         Anti Spam SMTP Proxy (FILTER) Server Installation "
echo "                                            FILTER Deployment Script by Mohamed Ashraf "
echo
echo
echo " -> Please run this script as root! "
echo " -> Hit enter to continue or CTRL-C to Abort"
echo
echo
read
echo "###################################################### PREPARING SYSTEM ######################################################"
echo "##############################################################################################################################"
sleep 2
echo
# PREPARING SYSTEM
apt-get update
apt-get dist-upgrade -y
apt-get upgrade -y
apt-get autoremove -y
apt-get autoclean
apt-get install ssh htop pydf unzip make -y
sysctl vm.swappiness=0

echo filter > /etc/hostname
MYIP=$(ifconfig eth0 | grep -i "inet addr:" | awk -F '[/:]' '{print $2}' | awk -F '[/ ]' '{print $1}')
echo "
127.0.0.1       localhost.localdomain localhost
$MYIP           filter.noor.net filter

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts
echo
echo
echo "###################################################### INSTALLING FILTER #####################################################"
echo "##############################################################################################################################"
echo
sleep 2

cd ~
mkdir filter-source
cd filter-source
wget http://garr.dl.sourceforge.net/project/scrollout/update/scrolloutf1.tar
tar -xvf scrolloutf1.tar
mkdir /var/www
cp -r scrolloutf1/www/* /var/www
chmod 755 /var/www/bin/*
/var/www/bin/install.sh