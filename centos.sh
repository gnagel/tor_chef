yum update -y
yum install -y gcc
yum install -y git
yum install -y libevent libevent-devel

wget 'http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/tor-0.2.2.33-1.el6.rf.x86_64.rpm'
rpm -Uvh tor*.rpm
