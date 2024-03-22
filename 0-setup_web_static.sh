#!/usr/bin/env bash
# Setup a web server for the deployment of web_static.

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root or using sudo."
    exit 1
fi

# Update package lists and install Nginx
apt update -y
apt install -y nginx

# Create directories
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

# Create HTML file
echo "<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <p>Nginx server test</p>
  </body>
</html>" | tee /data/web_static/releases/test/index.html

# Create symbolic link
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change ownership
chown -R ubuntu:ubuntu /data

# Add Nginx configuration if it doesn't exist already
if ! grep -q "location /hbnb_static" /etc/nginx/sites-enabled/default; then
    sudo sed -i '39 i\ \tlocation /hbnb_static {\n\t\talias /data/web_static/current;\n\t}\n' /etc/nginx/sites-enabled/default
fi

# Restart Nginx
sudo service nginx restart
