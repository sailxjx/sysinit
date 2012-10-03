#!/bin/bash
# install apr
cd ~/Downloads
wget -c http://mirror.bit.edu.cn/apache//apr/apr-1.4.6.tar.bz2 -O apr-1.4.6.tar.bz2
tar -xvf apr-1.4.6.tar.bz2
cd apr-1.4.6
./configure && make && sudo make install
# install apr-util
cd ~/Downloads
wget -c http://mirror.bjtu.edu.cn/apache//apr/apr-util-1.4.1.tar.bz2 -O apr-util-1.4.1.tar.bz2
tar -xvf apr-util-1.4.1.tar.bz2
cd apr-util-1.4.1
./configure --with-apr=/usr/local/apr && make && sudo make install
# install httpd
cd ~/Downloads
wget -c http://labs.mop.com/apache-mirror//httpd/httpd-2.4.3.tar.bz2 -O httpd-2.4.3.tar.bz2
tar -xvf httpd-2.4.3.tar.bz2
cd httpd-2.4.3
./configure \
    --prefix=/usr/local/httpd \
    --with-apr=/usr/local/apr \
    --with-apr-util=/usr/local/apr \
    --with-pcre=/usr \
    --enable-cache \
    --enable-mem-cache \
    --enable-mime-magic \
    --enable-expires \
    --enable-headers \
    --enable-usertrack \
    --enable-unique-id \
    --enable-proxy \
    --enable-proxy-connect \
    --enable-proxy-http \
    --enable-proxy-balancer \
    --enable-rewrite \
    --enable-so \
    --with-mpm=worker
make && sudo make install
sudo ln -s /usr/local/httpd/bin/* /usr/local/bin
sudo cp -r /usr/local/httpd/man/* /usr/local/man
exit 0
