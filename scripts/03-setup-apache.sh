#!/bin/bash
set -e

echo "==================================================="
echo " [ETAPA 3] Instalando Apache2, PHP e WordPress     "
echo "==================================================="

sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring php-xmlrpc php-zip php-soap php-intl

sudo systemctl enable apache2
sudo systemctl start apache2

echo "-> Baixando WordPress..."
cd /tmp
rm -rf wordpress latest.tar.gz
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

sudo rm -rf /var/www/html/wordpress
sudo mv wordpress /var/www/html/wordpress

sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/app_cms/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/usr_cms/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/SenhaCmsSegura123!/" /var/www/html/wordpress/wp-config.php

SALT_FILE=$(mktemp)
if curl -fsS https://api.wordpress.org/secret-key/1.1/salt/ -o "$SALT_FILE"; then
    sudo sed -i "/put your unique phrase here/d" /var/www/html/wordpress/wp-config.php
    sudo sed -i "/DB_COLLATE/r $SALT_FILE" /var/www/html/wordpress/wp-config.php
else
    echo "AVISO: não foi possível baixar os salts; mantendo os valores padrão."
fi
rm -f "$SALT_FILE"

sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

sudo systemctl restart apache2

IP_SERVIDOR=$(hostname -I | awk '{print $1}')
echo "==================================================="
echo " [CONCLUÍDO] WordPress pronto!                     "
echo " Acesse no navegador: http://${IP_SERVIDOR}/wordpress"
echo " Conclua a instalação em: http://${IP_SERVIDOR}/wordpress/wp-admin/install.php"
echo "==================================================="
