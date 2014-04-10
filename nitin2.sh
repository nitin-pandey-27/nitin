#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
 sudo apt-get install mysql-server mysql-client -y; # if not install then install
else
 sudo apt-get remove mysql-server mysql-client -y; # if install then uninstall and
 sudo apt-get install mysql-server mysql-client -y; # install to set the username and password
fi 

#if [ $(dpkg-query -W -f='${Status}' mysql-client 2>/dev/null | grep -c "ok installed") -eq 0 ];
#then
# sudo apt-get install mysql-server;
#fi 

# Creating database

sudo mysql -u root -proot -e 'create database `example.com_db`'
echo "database created"

if [ $(dpkg-query -W -f='${Status}' php5-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install php5-fpm -y;
else
  echo "php5-fpm already installed";
fi 

if [ $(dpkg-query -W -f='${Status}' php5-mysql 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install php5-mysql -y;
else
  echo "php5-mysql already installed";
fi

if [ $(dpkg-query -W -f='${Status}' php5-cli 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install php5-cli -y;
else
  echo "php5-cli already installed";
fi

if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install curl -y;                 # install curl
else
  echo "curl already installed";
fi

if [ $(dpkg-query -W -f='${Status}' ee 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  #sudo apt-get install curl                    # install curl
  sudo curl -sL rt.cx/ee | sudo bash           # install easy-engine
  sudo ee system install nginx -y                      # install nginx
  sudo ee site create example.com --wp         # install wordpress on example.com 
fi 

# The script will then ask user for domain name. 

read -p "Enter your domain name : " name;
#ifconfig;
read -p "Enter the ip address : " ipaddress;

sudo ifconfig eth0 "$ipaddress"

sudo chmod 666 /etc/hosts

sudo echo -e ""$ipaddress" \t  "$name" www."$name"" >> /etc/hosts;

# downloading the wordpress and changing the access


sudo mkdir -p /var/www/example.com/htdocs/ /var/www/example.com/logs/; 
cd /var/www/example.com/htdocs/;
sudo wget http://wordpress.org/latest.tar.gz;
sudo tar --strip-components=1 -xvf latest.tar.gz;
sudo rm /var/www/example.com/htdocs/latest.tar.gz;
sudo chown -R www-data:www-data /var/www/example.com/;



# Changing host entry in /etc/hosts

#sudo echo "$(ifconfig)   example.com" >> /etc/hosts;

#read -p "Enter your domain name : " name
#read -p "Enter your ip add: " ip

#sudo echo "$ip $name" >> /etc/hosts
#echo "search $name" >> /etc/resolv.conf
#sudo echo "$ip $name" >> /etc/hosts


#sudo echo "search $name" >> /etc/resolv.conf

# Create Nginx-config file for example.com

sudo cat << EOF > /etc/nginx/sites-available/example.com
server {
        server_name example.com www.example.com;

	access_log   /var/log/nginx/example.com.access.log;
	error_log    /var/log/nginx/example.com.error.log;

        root /var/www/example.com/htdocs;
        index index.php;

        location / {
                try_files $uri $uri/ /index.php?$args; 
        }

        location ~ \.php$ {
                try_files $uri =404;
                include fastcgi_params;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
        }
}
EOF

# Next, add example.com to Nginx sites-enabled folder:

sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

# to enable mysql support in php5-fpm

#sudo cat << EOF >> /etc/php5/cli/php.ini
#extension=mysql.so
#extension=mysqli.so
#EOF

sudo cat << EOF >> /etc/php5/fpm/php.ini
extension=mysql.so
extension=mysqli.so
EOF

# restarting the services

sudo service nginx reload
sudo service php5-fpm restart

xdg-open http://example.com





