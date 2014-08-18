#!/usr/bin/env sh

echo '*** Modifying webapp.conf with server_name $NGINX_SERVERNAME'
sed -i -e "s/server_name localhost;/server_name $NGINX_SERVERNAME;/g" /etc/nginx/sites-enabled/webapp.conf

echo '*** Modifying config.inc.php with MySQL host $MYSQL_HOST'
sed -i -e "s/localhost/$MYSQL_HOST/g" /home/app/webapp/public/config.inc.php