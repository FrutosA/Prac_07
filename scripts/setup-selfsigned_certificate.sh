#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -x

# Actualizamos los repositorio
apt update -y

#Actualizamos los paquetes
apt upgrade -y

#Incluimos las variables:
source .env


#Instalamos y actualizamos snapd

snap instal core

snap refresh core

#Eliminamos cualquier instalacion previa de certbot con apt

apr remove certbot

#Instalamos la aplicacion cerbot:

snap install --classic certbot

#Creamos un alias para la aplicacion cerbot 

ln -sf /snap/bin/certbot /usr/bin/certbot

#Ejecutamos el comando cerbot

sudo certbot --apache -m $CERTIFICATE_MAIL --agree-tos --no-eff-email -d $CERTIFICATE_DOMAIN --non-interactive