# php-fpm-apache-2.4
# Before running this ...

Make sure you uncomment the firewalld cmd to allow you to ssh. :) You can find it on line 75 of /install/prod.sh
Or disable firewalld.

## Vagrant
```bash
git clone https://github.com/bradallenfisher/php-fpm-apache-2.4-centos7.git; cd php-fpm-apache-2.4-centos7; vagrant up
```

## PROD
```bash
yum -y install git; git clone https://github.com/bradallenfisher/php-fpm-apache-2.4-centos7.git; cd php-fpm-apache-2.4-centos7/intall; chmod 700 prod.sh; ./prod.sh
```
