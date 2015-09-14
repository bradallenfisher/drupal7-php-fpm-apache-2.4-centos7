# php-fpm-apache-2.4
# Before running this ...

I recommend updating your ssh port and also changing the firewalld rules in prod.sh 
You can find it on line 75 of /install/prod.sh

## Vagrant
```bash
git clone https://github.com/bradallenfisher/php-fpm-apache-2.4-centos7.git; cd php-fpm-apache-2.4-centos7; vagrant up
```

## PROD
```bash
yum -y install git; git clone https://github.com/bradallenfisher/php-fpm-apache-2.4-centos7.git; cd php-fpm-apache-2.4-centos7/intall; chmod 700 prod.sh; ./prod.sh
```
