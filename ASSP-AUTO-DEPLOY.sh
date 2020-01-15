#! /bin/bash

clear
echo
echo "                                         Anti Spam SMTP Proxy (ASSP) Server Installation "
echo "                                            ASSP Deployment Script by Mohamed Ashraf "
echo
echo
echo " -> Please run this script as root! "
echo " -> Hit enter to continue or CTRL-C to Abort"
echo
echo " * Dont worry about any failed or skipped tests during CPAN initilization Phase.."
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

# PREPARING environment
apt-get install build-essential linux-headers-$(uname -r) -y
apt-get install perl perl-base  perl-depends perl-modules -y
apt-get install libssl-dev libdb-dev dh-make-perl -y

echo ASSP > /etc/hostname
MYIP=$(ifconfig eth0 | grep -i "inet addr:" | awk -F '[/:]' '{print $2}' | awk -F '[/ ]' '{print $1}')
echo "
127.0.0.1       localhost.localdomain localhost
$MYIP           assp.noor.net assp

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts
echo
echo
echo "###################################################### INSTALLING ASSP #######################################################"
echo "##############################################################################################################################"
echo
sleep 2
#INSTALL ASSP
apt-get install clamav clamav-daemon clamav-freshclam -y
apt-get install libperl-dev -y
freshclam -v
echo
echo
cd ~
mkdir ASSP-SOURCE
cd ASSP-SOURCE/
wget http://sourceforge.net/projects/assp/files/latest/download?source=files
mv download\?source\=files assp.zip
unzip assp.zip
mkdir /usr/share/assp
mkdir /usr/share/assp/spam
mkdir /usr/share/assp/notspam
mkdir /usr/share/assp/errors
mkdir /usr/share/assp/errors/spam
mkdir /usr/share/assp/errors/notspam
mv assp/* /usr/share/assp/
cd /usr/share/assp/
chown -R root:root /usr/share/assp
wget -O - http://cpanmin.us | perl - --self-upgrade
curl -L http://cpanmin.us | perl - --self-upgrade
(echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan
echo
echo
cd /root/ASSP-SOURCE
wget http://garr.dl.sourceforge.net/project/net-snmp/net-snmp/5.7.2.1/net-snmp-5.7.2.1.tar.gz
tar zxvf net-snmp-5.7.2.1.tar.gz
cd net-snmp-5.7.2.1
./configure
make
make install
echo
echo
echo "################################################## PREPARING CPAN MODULES ####################################################"
echo "##############################################################################################################################"
echo
sleep 2
echo
echo "###################################### PASS 1"
sleep 2
cpan YAML
cpan File::Scan::ClamAV
cpan Net::IP::Match::Regexp
cpan Net::SenderBase
cpan Tie::RDBM
cpan Net::Syslog
cpan Time::HiRes
cpan Net::SenderBase
cpan Tie::RDBM
cpan Net::Syslog
cpan Time::HiRes
cpan File::Scan::ClamAV
cpan NetSNMP::agent
cpan HTML::Entities
cpan Authen::SASL
cpan BerkeleyDB
cpan Convert::TNEF
cpan DB_File
cpan Digest::SHA1
cpan Email::MIME
cpan Email::Send
cpan File::ReadBackwards
cpan IO::Socket::INET6
cpan IO::Socket::SSL
cpan LWP::Simple
cpan Mail::DKIM::Verifier
cpan Mail::SPF
cpan Mail::SPF::Query
cpan Net::CIDR::Lite
cpan Net::IP
cpan Net::LDAP
cpan Net::SMTP::SSL
cpan NetAddr::IP::Lite
cpan Regexp::Optimizer
cpan Schedule::Cron
cpan Sys::CpuAffinity
cpan Sys::MemInfo
cpan Text::Unidecode
cpan Thread::State
cpan Unicode::GCString
cpan Archive::Extract
cpan Archive::Zip
cpan Archive::Tar
cpan IO::Compress::Gzip
cpan IO::Compress::Bzip2
cpan Filesys::DiskSpace
cpan Lingua::Stem::Snowball
cpan Lingua::Identify
cpan Mail::SRS
(echo force install File::Scan::ClamAV)|cpan

echo
echo "###################################### PASS 2"
sleep 2
cpan YAML
cpan File::Scan::ClamAV
cpan Net::IP::Match::Regexp
cpan Net::SenderBase
cpan Tie::RDBM
cpan Net::Syslog
cpan Time::HiRes
cpan Net::SenderBase
cpan Tie::RDBM
cpan Net::Syslog
cpan Time::HiRes
cpan File::Scan::ClamAV
cpan NetSNMP::agent
cpan HTML::Entities
cpan Authen::SASL
cpan BerkeleyDB
cpan Convert::TNEF
cpan DB_File
cpan Digest::SHA1
cpan Email::MIME
cpan Email::Send
cpan File::ReadBackwards
cpan IO::Socket::INET6
cpan IO::Socket::SSL
cpan LWP::Simple
cpan Mail::DKIM::Verifier
cpan Mail::SPF
cpan Mail::SPF::Query
cpan Net::CIDR::Lite
cpan Net::IP
cpan Net::LDAP
cpan Net::SMTP::SSL
cpan NetAddr::IP::Lite
cpan Regexp::Optimizer
cpan Schedule::Cron
cpan Sys::CpuAffinity
cpan Sys::MemInfo
cpan Text::Unidecode
cpan Thread::State
cpan Unicode::GCString
cpan Archive::Extract
cpan Archive::Zip
cpan Archive::Tar
cpan IO::Compress::Gzip
cpan IO::Compress::Bzip2
cpan Filesys::DiskSpace
cpan Lingua::Stem::Snowball
cpan Lingua::Identify
cpan Mail::SRS
(echo force install File::Scan::ClamAV)|cpan


echo
echo

cd /root/ASSP-SOURCE
wget http://assp.cvs.sourceforge.net/viewvc/assp/assp2/filecommander/1.05.ZIP
unzip 1.05.ZIP
cp -R 1.05/* /usr/share/assp/

cd /root/ASSP-SOURCE/
wget http://assp.cvs.sourceforge.net/viewvc/assp/assp2/lib/?view=tar
mv index.html?view=tar assp-lib.tar.gz
tar -xzf assp-lib.tar.gz
cp -R lib/* /usr/share/assp/lib/
mkdir Regex/
chown -R root:root /usr/share/assp

echo "################################################## FINILIZING INSTALLATION ###################################################"
echo "##############################################################################################################################"
echo
sleep 2



touch /etc/init.d/assp
echo '#!/bin/bash

# Start or stop ASSP


#


# original version by Ivo Schaap <ivo@lineau.nl> had issues on Debian. Modified by Mohamed Ashraf <mashraf@noor.net>.


#


### BEGIN INIT INFO


# Provides:          ASSP (Anti-Spam SMTP Proxy)


# Required-Start:    $syslog, $local_fs


# Required-Stop:     $syslog, $local_fs


# Default-Start:     2 3 4 5


# Default-Stop:      0 1 6


# Short-Description: Start ASSP


# Description:       Enable service provided by daemon.


### END INIT INFO
PATH=/bin:/usr/bin:/sbin:/usr/sbin
case "$1" in
start)
echo -en "Starting the Anti-Spam SMTP Proxy"
chmod 777 /var/run/clamav/clamd.ctl
echo -en "."
sleep 1
cd /usr/share/assp
echo -en "."
sleep 1
perl assp.pl 2>&1 > /dev/null &
echo -en "."
sleep 1
echo -en "."
sleep 1
echo -en "."
sleep 1
echo "[OK]"
echo
;;
stop)
echo
echo -n "Stopping the Anti-Spam SMTP Proxy"
echo -en "."
sleep 1
ASSPID1=$(ps ax | grep "perl assp.pl")
echo -en "."
sleep 1
ASSPID2=$(echo $ASSPID1 | { read first rest ; echo $first ; })
echo -en "."
sleep 1
kill -9 $ASSPID2
echo -en "."
sleep 1
echo -en "."
sleep 1
echo "[OK]"
echo
;;
restart)
$0 stop || true
$0 start
;;
*)
echo "Usage: /etc/init.d/assp {start|stop|restart}"


exit 1


;;
esac
exit 0
' > /etc/init.d/assp

chmod 775 /etc/init.d/assp
echo
echo " Created /etc/init.d/assp Daemon"
sleep 1
echo " ASSP System will be configuered to Start on system Startup "
sleep 1
echo " All Complete! "
echo
chown -R root:root /usr/share/assp
echo "###################################################### STARTING SYSTEM #######################################################"
echo "##############################################################################################################################"
echo
sleep 2

/etc/init.d/assp start

echo
echo
clear
echo "             ############ INSTALLATION COMPLETE ############"
echo
echo "    Please Configure the following points before using the application:"
echo "    -------------------------------------------------------------------"
echo "    1 - Configure the server Fully Qualifed Domain Name in /etc/hosts "
echo "    2 - Configure DNS resolve setting in /etc/resolv.conf"
echo "    3 - You can Login into the web interface at $MYIP:55555 with user: root , pass : nospam4me "
echo
echo "                            --ENJOY--"
echo
echo "           ## SYSTEM WILL REBOOT, HIT ENTER WHEN READY ##"
echo
echo
echo
echo
read
echo
echo
update-rc.d assp defaults
reboot
