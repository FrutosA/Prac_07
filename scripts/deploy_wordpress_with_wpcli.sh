#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -xe

#Incluimos las variables:
source .env

#Eliminamos descargas previas:

 rm -rf /tmp/wp-cli.phar

#Descargamos el codigo fuente: 

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

#Le asignamos permisos de ejecución al archivo wp-cli.phar

chmod +x /tmp/wp-cli.phar

#Movemos la utilidad

mv /tmp/wp-cli.phar /usr/local/bin/wp

#Eliminamos descargas previas:

 rm -rf /var/www/html/*

#Descargamos el codigo fuente de wordperss

wp core download --locale=es_ES --path=/var/www/html --allow-root

#Base de datos y usuario:

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

#Creamos el archivo wp-config
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --path=/var/www/html \
  --allow-root

# Instalación de WordPress 
  wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_MAIL \
  --path=/var/www/html \
  --allow-root

#Actualización de los plugins

wp plugin update --all

# Actualización de los themes a la última versión

wp theme update --all

#Comprobar la versión del core de WordPress

wp core check-update --allow-root

#Actualizar el core de WordPress a la última versión

wp core update --allow-root

#Instalar y activar un theme (Sysney)

wp theme install sydney --activate

# Eliminar los themes que están inactivos

wp theme delete $(wp theme list --status=inactive --field=name)

#Instalar plugins:
