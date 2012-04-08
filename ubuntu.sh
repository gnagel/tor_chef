# Install the latest version of tor, with the tor2web flag
sudo apt-add-repository http://deb.torproject.org/torproject.org
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
sudo apt-get -y update >>/tmp/install.log
sudo apt-get -y install git >>/tmp/install.log
sudo apt-get -y install libtool >>/tmp/install.log
sudo apt-get -y install deb.torproject.org-keyring dpkg-dev autoconf >>/tmp/install.log
sudo apt-get -y build-dep tor >>/tmp/install.log

git clone git://git.torproject.org/debian/tor.git
cd tor
./configure && make && sudo make install

sudo /etc/init.d/tor restart

# Install privoxy to translate normal web requests to SOCKS, which Tor speaks:
sudo apt-get -y install privoxy
sudo sh -c "curl http://tor2web.org/conf/privoxy-config > /etc/privoxy/config"
sudo /etc/init.d/privoxy restart
