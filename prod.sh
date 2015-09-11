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
systemctl enable mysqld.service
systemctl start  mysqld.service

# php
yum install -y php56w php56w-fpm php56w-opcache php56w-cli php56w-common php56w-gd php56w-mbstring php56w-mcrypt php56w-pecl-apcu php56w-pdo php56w-xml php56w-mysqlnd
# fix date timezone errors
sed -i 's#;date.timezone =#date.timezone ="America/New York"#g' /etc/php.ini
systemctl enable php-fpm.service
systemctl start php-fpm.service

# varnish
## todo -->
rpm --nosignature -i https://repo.varnish-cache.org/redhat/varnish-4.0.el7.rpm
yum install -y varnish

#add the ProxyPassMatch
sed -i 's/IncludeOptional conf/#IncludeOptional conf/g' /etc/httpd/conf/httpd.conf
cat << EOF >> /etc/httpd/conf/httpd.conf
<IfModule proxy_module>
  ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/var/www/html/$1
</IfModule>
IncludeOptional conf.d/*.conf
EOF

#comment out the addHandler mod_php stuff
sed -i 's/AddHandler php5-script .php/#AddHandler php5-script .php/g' /etc/httpd/conf.d/php.conf
sed -i 's/AddType text/#AddType text/g' /etc/httpd/conf.d/php.conf

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer

cat htaccess.conf > /etc/httpd/conf.d/htaccess.conf
cat www.conf > /etc/php-fpm.d/www.conf
cat 00-base.conf > /etc/httpd/conf.modules.d/00-base.conf
cat 00-dav.conf > /etc/httpd/conf.modules.d/00-dav.conf
cat 00-lua.conf > /etc/httpd/conf.modules.d/00-lua.conf
cat 00-mpm.conf > /etc/httpd/conf.modules.d/00-mpm.conf
cat 00-proxy.conf > /etc/httpd/conf.modules.d/00-proxy.conf
cat 01-cgi.conf > /etc/httpd/conf.modules.d/01-cgi.conf
cat security.conf > /etc/httpd/conf.d/security.conf
cat opcache.ini > /etc/php.d/opcache.ini
cat default.vcl > /etc/varnish/default.vcl
cat varnish.params > /etc/varnish/varnish.params

systemctl restart httpd.service
systemctl restart php-fpm.service
