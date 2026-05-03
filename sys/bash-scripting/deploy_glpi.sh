#!/bin/bash

# --- Variables ---
DB_NAME="glpi"
DB_USER="glpi"
DB_PASS="it-firefight"
GLPI_VER="11.0.5"
GLPI_URL="https://github.com/glpi-project/glpi/releases/download/${GLPI_VER}/glpi-${GLPI_VER}.tgz"

# --- 1. Mise à jour et Installation des paquets ---
echo "Mise à jour du système..."
apt update -y && apt upgrade -y

echo "Installation d'Apache, MariaDB et PHP..."
apt install -y apache2 mariadb-server \
php php-{fpm,curl,zip,mbstring,xml,intl,mysql,imagick,gd,bz2,ftp,bcmath,gmp,exif,apcu,ldap} \
libapache2-mod-php

# --- 2. Configuration de la base de données ---
# On utilise ici un "Here Document" (EOF) pour envoyer les commandes à mysql sans interface
echo "Configuration de MariaDB..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
FLUSH PRIVILEGES;
EOF

# --- 3. Téléchargement et Installation de GLPI ---
echo "Téléchargement de GLPI v${GLPI_VER}..."
cd /var/www
wget $GLPI_URL
tar -xzf glpi-${GLPI_VER}.tgz
rm glpi-${GLPI_VER}.tgz

echo "Configuration des permissions..."
chown -R www-data:www-data /var/www/glpi
chmod -R 755 /var/www/glpi

# --- 4. Configuration d'Apache ---
echo "Configuration du VirtualHost..."
# On crée le fichier directement avec 'cat' pour éviter d'utiliser 'nano' manuellement
cat <<EOF > /etc/apache2/sites-available/glpi.conf
<VirtualHost *:8080>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/glpi/public
    DirectoryIndex index.php index.html

    <Directory /var/www/glpi/public>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted

        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule ^(.*)$ index.php [QSA,L]
        </IfModule>
    </Directory>

    LogLevel debug
    ErrorLog ${APACHE_LOG_DIR}/glpi_error.log
    CustomLog ${APACHE_LOG_DIR}/glpi_access.log combined
</VirtualHost>
EOF

# Dire à Apache d'écouter sur le port 8080 en plus du 80 (ou à la place)
sed -i '/Listen 80/a Listen 8080' /etc/apache2/ports.conf

# Activation du site et des modules
a2ensite glpi.conf
a2dissite 000-default.conf
a2enmod rewrite
systemctl restart apache2

echo "Installation terminée. Accédez à GLPI via l'adresse IP de votre serveur."
