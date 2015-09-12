#!/bin/bash

# install apache
yum install nano vim wget curl git httpd -y

# get some repos
rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# get latest mysql
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
yum localinstall mysql-community-release-el7-5.noarch.rpm -y
yum update -y
yum install mysql-community-server -y

# php
yum install -y php56w php56w-fpm php56w-opcache php56w-cli php56w-common php56w-gd php56w-mbstring php56w-mcrypt php56w-pecl-apcu php56w-pdo php56w-xml php56w-mysqlnd

# varnish
rpm --nosignature -i https://repo.varnish-cache.org/redhat/varnish-4.0.el7.rpm
yum install -y varnish

# Add Config accross the instance
cat default.vcl > /etc/varnish/default.vcl
cat varnish.params > /etc/varnish/varnish.params
cat www.conf > /etc/php-fpm.d/www.conf
cat proxy.conf > /etc/php-fpm.d/proxy.conf
cat opcache.ini > /etc/php.d/opcache.ini
cat 00-base.conf > /etc/httpd/conf.modules.d/00-base.conf
cat 00-dav.conf > /etc/httpd/conf.modules.d/00-dav.conf
cat 00-lua.conf > /etc/httpd/conf.modules.d/00-lua.conf
cat 00-mpm.conf > /etc/httpd/conf.modules.d/00-mpm.conf
cat 00-proxy.conf > /etc/httpd/conf.modules.d/00-proxy.conf
cat 01-cgi.conf > /etc/httpd/conf.modules.d/01-cgi.conf
cat htaccess.conf > /etc/httpd/conf.d/htaccess.conf
cat php.conf > /etc/httpd/conf.d/php.conf
cat php-fpm.conf > /etc/httpd/conf.d/php-fpm.conf
cat security.conf > /etc/httpd/conf.d/security.conf


# Minor config change to main apache file.
sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf.d/httpd.conf

# fix date timezone errors
sed -i 's#;date.timezone =#date.timezone ="America/New York"#g' /etc/php.ini

# Make sue services stay on after reboot
systemctl enable httpd.service
systemctl enable mysqld.service
systemctl enable php-fpm.service
systemctl enable varnish.service

# Start all the services we use.
systemctl start php-fpm.service
systemctl start  mysqld.service
systemctl start httpd.service
systemctl start varnish.service

# Install Drush globally.
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer
