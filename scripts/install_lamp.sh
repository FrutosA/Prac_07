#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -xe

#Actualizar los repositorios
apt update

#Acltualizamos los paquetes
apt upgrade -y

#Incluimos las variables:
source .env

#Instalamos el servidor web Apache
apt install apache2 -y

#Instalamos el sistema de gestores de base de datos MySQL
apt install mysql-server -y

#Instalamos PHP
apt install php libapache2-mod-php php-mysql -y

#Copiar el archivo de configuración de Apache
rm -rf /etc/apache2/sites-available/000-default.conf

cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

#Reinciamos el servicio de Apache
systemctl restart apache2.service
