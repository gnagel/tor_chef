# Install the latest version of tor
sudo apt-add-repository http://deb.torproject.org/torproject.org
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
sudo apt-get -y update >>/tmp/install.log
sudo apt-get -y install git >>/tmp/install.log
sudo apt-get -y install libtool >>/tmp/install.log
sudo apt-get -y install deb.torproject.org-keyring dpkg-dev autoconf >>/tmp/install.log
sudo apt-get -y build-dep tor >>/tmp/install.log

git clone git://git.torproject.org/debian/tor.git /tmp/tor && cd /tmp/tor && ./configure && make && sudo make install
sudo sh -c "ln -sf /etc/tor/torrc /usr/local/etc/tor/torrc"
sudo cp torrc.config /etc/tor/torrc
sudo chown -R $(whoami) /var/lib/tor
sudo sh -c "echo '_tor hard nofile 32768' >> /etc/security/limits.conf"

# Setup the firewall
sudo mkdir -p /etc/sysconfig
sudo sh -c "iptables-save > /etc/sysconfig/iptables.default"
sudo sh -c "iptables-save > /etc/sysconfig/iptables.test"
sudo sh -c "cat iptables.config >> /etc/sysconfig/iptables.test"
sudo sh -c "iptables-restore < /etc/sysconfig/iptables.test"
sudo sh -c "iptables -L" # verify the rules are correct
sudo sh -c "iptables-save > /etc/sysconfig/iptables"

sudo /etc/init.d/tor restart

# Install privoxy to translate normal web requests to SOCKS, which Tor speaks:
sudo apt-get -y install privoxy
sudo sh -c "curl http://tor2web.org/conf/privoxy-config > /etc/privoxy/config"
sudo /etc/init.d/privoxy restart
