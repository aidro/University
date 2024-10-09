resource "proxmox_lxc" "basic" {
  target_node  = "srv01"
  hostname     = var.hostname
  ostemplate   = var.iso
  password     = var.password
  unprivileged = true

  rootfs {
    storage = var.disk_storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = var.ip_address
  }

  # Cloud-init script to install WordPress
  sshkeys = file("~/.ssh/id_rsa.pub")
  # ipconfig0 = "ip=dhcp"

  # User data to provision WordPress and required services
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

    systemctl restart apache2
EOF

  autostart = true
}
 