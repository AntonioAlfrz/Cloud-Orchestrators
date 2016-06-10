#!/bin/sh
# sudo apt-get update && sudo apt-get install -y nagios3
cd ~
wget http://www.nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz
tar xvf nagios-plugins-2.1.1.tar.gz
cd nagios-plugins-2.1.1
sudo apt-get install -y build-essential
./configure
make
sudo make install
cd ~
wget https://sourceforge.net/projects/nagios/files/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
tar xzf nrpe-2.15.tar.gz
cd nrpe-2.8
sudo apt-get install -y libssl-dev
./configure --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make all
sudo make install
# /usr/local/nagios/libexec
