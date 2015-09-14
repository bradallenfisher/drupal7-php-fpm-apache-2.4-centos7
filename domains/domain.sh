#!/bin/bash
# BEGIN CONFIGURATION ==========================================================
SITES_DIR="/var/www/html/"

# END CONFIGURATION ============================================================
cd $SITES_DIR
  for d in *
    do
      if [[ -d $d ]]
      then
        echo $d$1
        echo ------------------------
        cat > /etc/httpd/conf.d/${d/com/conf}$1 <<EOF
        <VirtualHost *:8080>
          ServerName $d$1
          ServerAlias www.$d$1
          DocumentRoot /var/www/html/$d$1

          <Directory /var/www/html/$d$1>
            Include /var/www/html/$d$1/.htaccess
          </Directory>

          # PHP-FPM Server
          <LocationMatch "^/(.*\.php(/.*)?)$">
            ProxyPass fcgi://127.0.0.1:9000/var/www/html/$d$1/\$1
          </LocationMatch>

        </VirtualHost>
EOF
      fi
  done
