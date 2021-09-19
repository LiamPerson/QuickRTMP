#!/bin/bash

# Settings
NGINX_VERSION=1.21.3
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "Are you sure you wish to install NGINX $NGINX_VERSION with the RTMProtocol on this server\? [y/n] \nThis will also install required dependencies: ufw unzip build-essential libpcre3 libpcre3-dev libssl-dev"
read -n 1 -r -s
if [[ $REPLY =~ ^[Yy]$ ]]
then 
	echo -e "Installing dependencies ...\n"
	apt-get -y install build-essential libpcre3 libpcre3-dev libssl-dev unzip ufw
	cd ~
	echo -e "Downloading NGINX $NGINX_VERSION ...\n"
	wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
	echo -e "Downloading NGINX RTMP module ...\n"
	wget https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/dev.zip
	echo -e "Unzipping files ...\n"
	tar -zxvf nginx-$NGINX_VERSION.tar.gz
	unzip dev.zip
	cd nginx-$NGINX_VERSION
	echo -e "Building NGINX ...\n"
	$SCRIPT_DIR/nginx-$NGINX_VERSION/configure --add-module=../nginx-rtmp-module-dev && make && make install
	echo -e "Adding RTMP to NGINX configuration ...\n"
	printf "rtmp {
				server {
					listen 1935;
					chunk_size 4096;
					application live {
						live on;
						record off;
					}
				}
			}" >> /usr/local/nginx/conf/nginx.conf
	/usr/local/nginx/sbin/nginx
	echo -e "Allow RTMP's port 1935 through firewall using Uncomplicated Firewall (UFW) ? [y/n]"
	read -n 1 -r -s
	if [[ $REPLY =~ ^[Yy]$ ]]
	then 
		echo -e "Adding UFW rule ...\n"
		ufw allow 1935
		ufw enable
	fi
	echo -e "Cleaning up files ...\n"
	rm -rfv nginx-$NGINX_VERSION
	rmdir nginx-$NGINX_VERSION
	rm dev.zip
	rm nginx-$NGINX_VERSION.tar.gz
	echo -e "\nFinished!\n"
else
	echo -e "\nExiting...\n"
fi