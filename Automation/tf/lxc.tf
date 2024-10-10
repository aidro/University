resource "proxmox_lxc" "basic" {
  target_node  = var.node
  hostname     = var.hostname
  ostemplate   = var.iso
  password     = var.password
  unprivileged = true
  start        = true
  cores        = "2"
  memory       = "8192"
  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  rootfs {
    storage = var.disk_storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = "10.24.49.200/24"
    gw     = "10.24.49.1"
  }

  timeouts {
    create = "2m"
  }

  # Use provisioners to install Docker and configure services
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/id_rsa")
      host     = "10.24.49.200"
    }

    # Step 1: Install Docker
    inline = [
      "apt-get update",
      "apt-get install -y docker",
      "systemctl enable docker",
      "systemctl start docker",
      "apt install -y docker-compose"
      "systemctl start docker-compose"
    ]
  }

  # Step 2: Use Docker to deploy WordPress and MySQL
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/id_rsa")
      host     = "10.24.49.200"
    }

    inline = [
      "mkdir -p /opt/wordpress",

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