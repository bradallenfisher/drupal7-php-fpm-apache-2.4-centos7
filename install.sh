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
yum install -y php56w-fpm
# fix date timezone errors
sed -i 's/;date.timezone=/date.timezone ="America/New York"/g' /etc/php.ini
systemctl enable php-fpm.service
systemctl start php-fpm.service

#add the ProxyPassMatch
sed -i 's/IncludeOptional conf/#IncludeOptional conf/g' /etc/httpd/conf/httpd.conf
cat << EOF >> /etc/httpd/conf/httpd.conf
<IfModule proxy_module>
  ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/var/www/html/$1
</IfModule>
IncludeOptional conf.d/*.conf
EOF
