 # Cloud-init script to install WordPress
  sshkeys = file("~/.ssh/id_rsa.pub")
  ipconfig0 = "ip=dhcp"

  cloud_init = <<EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2 php libapache2-mod-php mariadb-server php-mysql wget

    # Set up MySQL for WordPress
    mysql -u root -e "CREATE DATABASE wordpress;"
    mysql -u root -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    # Download and configure WordPress
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xvzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz
    chown -R www-data:www-data /var/www/html/
    chmod -R 755 /var/www/html/

    # Restart Apache
    systemctl restart apache2
EOF

  # Start the VM automatically
  autostart = true
}