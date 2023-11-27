# Prac_07
## ¿QUE TENEMOS QUE HACER?
├── README.md

├── conf

│   └── 000-default.conf

├── htaccess

│   └── .htaccess

└── scripts

    ├── .env
    
    ├── install_lamp.sh
    
    ├── setup_letsencrypt_https.sh
    
    └── deploy_wordpress_with_wpcli.sh

### Instal Lamp:

Muestra todos los comandos que se van ejecutando:
````
set -xe


````

Actualizar los repositorios
````
apt update

````

Acltualizamos los paquetes
````
apt upgrade -y

````
Incluimos las variables:
````
source .env

````

Instalamos el servidor web Apache
````
apt install apache2 -y

````

Instalamos el sistema de gestores de base de datos MySQL
````
apt install mysql-server -y

````
Instalamos PHP
````
apt install php libapache2-mod-php php-mysql -y

````

Copiar el archivo de configuración de Apache
````
rm -rf /etc/apache2/sites-available/000-default.conf

cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

````

Reinciamos el servicio de Apache
````
systemctl restart apache2.service

````

### env
````
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wp_user
WORDPRESS_DB_PASSWORD=wp_pass

IP_CLIENTE_MYSQL=localhost
WORDPRESS_TITLE="Sitio web iaw"
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASS=admin
WORDPRESS_ADMIN_MAIL=demo@demo.es

WORDPRESS_DB_HOST=localhost

CERTIFICATE_MAIL=demo@demo.com
CERTIFICATE_DOMAIN=andresdomine.bounceme.net

SECURITY_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)

````

### Certifcado :
Actualizamos los repositorio
````
apt update -y

````
Actualizamos los paquetes
````
apt upgrade -y

````
Incluimos las variables:
````
source .env

````

Instalamos y actualizamos snapd
````
snap instal core

snap refresh core

````

Eliminamos cualquier instalacion previa de certbot con apt
````
apr remove certbot

````
Instalamos la aplicacion cerbot:
````
snap install --classic certbot

````
Creamos un alias para la aplicacion cerbot 
````
ln -sf /snap/bin/certbot /usr/bin/certbot

````
Ejecutamos el comando cerbot
````
sudo certbot --apache -m $CERTIFICATE_MAIL --agree-tos --no-eff-email -d $CERTIFICATE_DOMAIN --non-interactive

````

### Wordpress

Incluimos las variables:
````
source .env

````
Eliminamos descargas previas:
````
 rm -rf /tmp/wp-cli.phar

````
Descargamos el codigo fuente: 
````
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

````
Le asignamos permisos de ejecución al archivo wp-cli.phar
````
chmod +x /tmp/wp-cli.phar

````
Movemos la utilidad
````
mv /tmp/wp-cli.phar /usr/local/bin/wp

````
Eliminamos descargas previas:
````
 rm -rf /var/www/html/*

````
Descargamos el codigo fuente de wordperss
````
wp core download --locale=es_ES --path=/var/www/html --allow-root

````
Base de datos y usuario:
````
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

````
Creamos el archivo wp-config
````
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --path=/var/www/html \
  --allow-root

````
Instalación de WordPress 
````
  wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_MAIL \
  --path=/var/www/html \
  --allow-root

````
Actualización de los plugins
````
wp plugin update --all --path=/var/www/html --allow-root
````
Actualización de los themes a la última versión
````
wp theme update --all --path=/var/www/html --allow-root
````
Comprobar la versión del core de WordPress
````
wp core check-update  --path=/var/www/html --allow-root
````
Actualizar el core de WordPress a la última versión
````
wp core update --path=/var/www/html --allow-root
````
Instalar y activar un theme (Sysney)
````
wp theme install sydney --path=/var/www/html --activate --allow-root
````
 Eliminar los themes que están inactivos
````
wp theme delete $(wp theme list --status=inactive --field=name --path=/var/www/html --allow-root) --path=/var/www/html --allow-root
````
Actualizamos los plugins:
````
wp plugin update --all --allow-root
````
Instalar plugins:
````
wp plugin install wps-hide-login --activate  --path=/var/www/html --allow-root
wp plugin install permalink-manager --activate --path=/var/www/html --allow-root
wp plugin install disable-media-permalink-by-hardweb-it --activate --path=/var/www/html --allow-root
wp plugin install tutor --activate --path=/var/www/html --allow-root

````
Elimininamos plugins que estan inacctivos:
````
wp plugin delete $(wp plugin list --status=inactive --field=name --path=/var/www/html --allow-root) --path=/var/www/html --allow-root

````



