#!/bin/bash
# BEGIN CONFIGURATION ==========================================================
SITES_DIR="/var/www/html/"

# END CONFIGURATION ============================================================
cd $SITES_DIR
  for d in *
    do
      if [[ -d $d ]]
      then
        echo $d
        echo ------------------------
        cat > /etc/httpd/conf.d/${d/com/conf} <<EOF
        <VirtualHost *:8080>
          ServerName $d
          ServerAlias www.$d
          DocumentRoot /var/www/html/$d

          <Directory /var/www/html/$d>
            Include /var/www/html/$d/.htaccess
          </Directory>

          # PHP-FPM Server
          <LocationMatch "^/(.*\.php(/.*)?)$">
            ProxyPass fcgi://127.0.0.1:9000/var/www/html/$d/\$1
          </LocationMatch>

        </VirtualHost>
EOF
      fi
  done
