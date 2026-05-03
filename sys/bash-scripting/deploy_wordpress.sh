#!/bin/bash

# --- Variables ---
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASS="it-firefight" # Changez-le !
WP_URL="https://wordpress.org/latest.tar.gz"

# --- 1. Mise à jour et Installation des paquets ---
echo "Mise à jour du système..."
apt update -y && apt upgrade -y

echo "Installation d'Apache, MariaDB et PHP..."
# WordPress nécessite quelques extensions PHP spécifiques (ex: gd, xml, imagick)
apt install -y apache2 mariadb-server \
php php-curl php-fpm php-bcmath php-gd php-imagick php-intl php-mbstring php-mysql php-xml php-zip \
libapache2-mod-php

# --- 2. Configuration de la base de données ---
echo "Configuration de MariaDB..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
FLUSH PRIVILEGES;
EOF

# --- 3. Téléchargement et Installation de WordPress ---
echo "Téléchargement de la dernière version de WordPress..."
cd /var/www
wget $WP_URL
tar -xzf latest.tar.gz
rm latest.tar.gz

# Note : Le dossier extrait s'appelle par défaut 'wordpress'
echo "Configuration des permissions..."
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# --- 4. Configuration d'Apache ---
echo "Configuration du VirtualHost..."
cat <<EOF > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/wordpress

    <Directory /var/www/wordpress>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/wordpress_error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress_access.log combined
</VirtualHost>
EOF

# Activation du site et des modules
a2ensite wordpress.conf
a2dissite 000-default.conf
a2enmod rewrite
systemctl restart apache2

echo "--------------------------------------------------------"
echo "Installation terminée."
echo "1. Accédez à l'IP de votre serveur dans votre navigateur."
echo "2. Utilisez les informations suivantes pour l'assistant :"
echo "   - Base : ${DB_NAME}"
echo "   - Utilisateur : ${DB_USER}"
echo "   - Mot de passe : ${DB_PASS}"
echo "   - Hôte : localhost"
echo "--------------------------------------------------------"
