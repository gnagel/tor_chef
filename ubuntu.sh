###
# Created from the instructions:
#	http://tor2web.org/config
#	http://www.tequilafish.com/2009/06/21/slicehost-setting-up-a-tor-relay-on-fedora-to-help-keep-iran-connected-iranelection/
###

# Create the directoryies we will need for tor & privoxy
mkdir -p /usr/local/etc/tor/
sudo mkdir -p /var/lib/tor /var/log/tor /usr/local/etc/tor/
sudo chown -R root /var/lib/tor /var/log/tor
sudo mkdir -p /etc/sysconfig
DATE=$(date '+%Y-%m-%d')

# Install the latest version of tor
sudo apt-add-repository http://deb.torproject.org/torproject.org
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
sudo apt-get -y update
# Git is needed to clone the repo
# libtool is needed for the autogen & configure scripts
# deb.torproject.org-keyring dpkg-dev autoconf are needed for the make
sudo apt-get -y install git 
sudo apt-get -y install libtool 
sudo apt-get -y install libevent-dev 
sudo apt-get -y install deb.torproject.org-keyring dpkg-dev autoconf
sudo apt-get -y build-dep tor

# Clone and install Tor
git clone git://git.torproject.org/debian/tor.git
cd tor
./autogen.sh
./configure
make
sudo make install
sudo cp ./debian/tor.init /etc/init.d/tor
sudo chmod 744 /etc/init.d/tor

# Perform all of the setup for the tor server
cd /usr/local/etc/tor/
sudo sh -c "mv ./torrc ./torrc.$DATE; curl 'https://raw.github.com/gnagel/tor_chef/master/torrc.config' > ./torrc"
sudo sh -c "echo '_tor hard nofile 32768' >> /etc/security/limits.conf"

# Setup the firewall
sudo mkdir -p /etc/sysconfig
cd /etc/sysconfig/
sudo sh -c "iptables-save > ./iptables.default.$DATE"
sudo sh -c "iptables -A INPUT -p tcp --dport 9001 -j ACCEPT"
sudo sh -c "iptables -A INPUT -p tcp --dport 9030 -j ACCEPT"
sudo sh -c "iptables -A OUTPUT -j ACCEPT"
sudo sh -c "iptables -L" # verify the rules are correct
sudo sh -c "iptables-save > ./iptables"

sudo /etc/init.d/tor restart

# Install privoxy to translate normal web requests to SOCKS, which Tor speaks:
sudo apt-get -y install privoxy
sudo sh -c "curl http://tor2web.org/conf/privoxy-config > /etc/privoxy/config"
sudo /etc/init.d/privoxy restart
