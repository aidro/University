resource "proxmox_lxc" "basic" {
  target_node  = var.node
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

  # Use provisioners to install Docker and configure services
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.password
      host     = "10.24.49.200"
    }

    # Step 1: Install Docker
    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -",
      "add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable'",
      "apt-get update",
      "apt-get install -y docker-ce",
      "systemctl enable docker",
      "systemctl start docker",
    ]
  }

  # Step 2: Use Docker to deploy WordPress and MySQL
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.password
      host     = "10.24.49.200"
    }

    inline = [
      # Install Docker Compose (optional, for easier container management)
      "curl -L https://github.com/docker/compose/releases/download/v2.29.7/docker-compose-linux-x86_64 /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",

      # Create a directory for the WordPress setup
      "mkdir -p /opt/wordpress",

      # Create a Docker Compose file for WordPress and MySQL
      "echo 'version: \"3\"' > /opt/wordpress/docker-compose.yml",
      "echo 'services:' >> /opt/wordpress/docker-compose.yml",
      "echo '  db:' >> /opt/wordpress/docker-compose.yml",
      "echo '    image: mysql:5.7' >> /opt/wordpress/docker-compose.yml",
      "echo '    restart: always' >> /opt/wordpress/docker-compose.yml",
      "echo '    environment:' >> /opt/wordpress/docker-compose.yml",
      "echo '      MYSQL_ROOT_PASSWORD: somewordpress' >> /opt/wordpress/docker-compose.yml",
      "echo '      MYSQL_DATABASE: wordpress' >> /opt/wordpress/docker-compose.yml",
      "echo '      MYSQL_USER: wordpress' >> /opt/wordpress/docker-compose.yml",
      "echo '      MYSQL_PASSWORD: wordpress' >> /opt/wordpress/docker-compose.yml",
      "echo '  wordpress:' >> /opt/wordpress/docker-compose.yml",
      "echo '    depends_on:' >> /opt/wordpress/docker-compose.yml",
      "echo '      - db' >> /opt/wordpress/docker-compose.yml",
      "echo '    image: wordpress:latest' >> /opt/wordpress/docker-compose.yml",
      "echo '    restart: always' >> /opt/wordpress/docker-compose.yml",
      "echo '    ports:' >> /opt/wordpress/docker-compose.yml",
      "echo '      - \"8080:80\"' >> /opt/wordpress/docker-compose.yml",
      "echo '    environment:' >> /opt/wordpress/docker-compose.yml",
      "echo '      WORDPRESS_DB_HOST: db:3306' >> /opt/wordpress/docker-compose.yml",
      "echo '      WORDPRESS_DB_USER: wordpress' >> /opt/wordpress/docker-compose.yml",
      "echo '      WORDPRESS_DB_PASSWORD: wordpress' >> /opt/wordpress/docker-compose.yml",
      "echo '      WORDPRESS_DB_NAME: wordpress' >> /opt/wordpress/docker-compose.yml",

      # Start the Docker containers
      "docker-compose -f /opt/wordpress/docker-compose.yml up -d",
    ]
  }
}