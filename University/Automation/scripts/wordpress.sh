echo    "curl -L https://github.com/docker/compose/releases/download/v2.29.7/docker-compose-linux-x86_64 /usr/local/bin/docker-compose" \
        "chmod +x /usr/local/bin/docker-compose" \
        "mkdir -p /opt/wordpress" \
        "echo 'version: \"3\"' > /opt/wordpress/docker-compose.yml" \
        "echo 'services:' >> /opt/wordpress/docker-compose.yml" \
        "echo '  db:' >> /opt/wordpress/docker-compose.yml" \
        "echo '    image: mysql:5.7' >> /opt/wordpress/docker-compose.yml" \
        "echo '    restart: always' >> /opt/wordpress/docker-compose.yml" \
        "echo '    environment:' >> /opt/wordpress/docker-compose.yml" \
        "echo '      MYSQL_ROOT_PASSWORD: somewordpress' >> /opt/wordpress/docker-compose.yml" \
        "echo '      MYSQL_DATABASE: wordpress' >> /opt/wordpress/docker-compose.yml" \
        "echo '      MYSQL_USER: wordpress' >> /opt/wordpress/docker-compose.yml" \
        "echo '      MYSQL_PASSWORD: wordpress' >> /opt/wordpress/docker-compose.yml" \
        "echo '  wordpress:' >> /opt/wordpress/docker-compose.yml" \
        "echo '    depends_on:' >> /opt/wordpress/docker-compose.yml" \
        "echo '      - db' >> /opt/wordpress/docker-compose.yml" \
        "echo '    image: wordpress:latest' >> /opt/wordpress/docker-compose.yml" \
        "echo '    restart: always' >> /opt/wordpress/docker-compose.yml" \
        "echo '    ports:' >> /opt/wordpress/docker-compose.yml" \
        "echo '      - \"8080:80\"' >> /opt/wordpress/docker-compose.yml" \
        "echo '    environment:' >> /opt/wordpress/docker-compose.yml" \
        "echo '      WORDPRESS_DB_HOST: db:3306' >> /opt/wordpress/docker-compose.yml" \
        "echo '      WORDPRESS_DB_USER: wordpress' >> /opt/wordpress/docker-compose.yml" \
        "echo '      WORDPRESS_DB_PASSWORD: wordpress' >> /opt/wordpress/docker-compose.yml" \
        "echo '      WORDPRESS_DB_NAME: wordpress' >> /opt/wordpress/docker-compose.yml" \
        "docker-compose -f /opt/wordpress/docker-compose.yml up -d"