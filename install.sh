#!/bin/bash
echo -e "Are you sure you wish to install NGINX 1.21.3 with the RTMProtocol on this server\? [y/n] \nThis will also install required dependencies build-essential libpcre3 libpcre3-dev libssl-dev"
read -n 1 -r -s
if [[ $REPLY =~ ^[Yy]$ ]]
then 
	echo -e "Installing dependencies ...\n"
	apt-get install build-essential libpcre3 libpcre3-dev libssl-dev
	cd ~
	echo -e "Downloading NGINX 1.21.3 ...\n"
	wget http://nginx.org/download/nginx-1.21.3.tar.gz
	echo -e "Downloading NGINX RTMP module ...\n"
	wget https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/dev.zip
	echo -e "Unzipping files ...\n"
	tar -zxvf nginx-1.21.3.tar.gz
	unzip dev.zip
	cd nginx-1.21.3
	echo -e "Building NGINX ...\n"
	./configure --add-module=../nginx-rtmp-module-dev
	make
	make install
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
	echo -e "\nFinished!\n"
else
	echo -e "\nExiting...\n"
fi