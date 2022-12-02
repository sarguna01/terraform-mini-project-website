#!/bin/bash
sudo yum install httpd -y
sudo systemctl start httpd.service
sudo wget -P /var/www/html/ https://www.free-css.com/assets/files/free-css-templates/download/page285/capiclean.zip
sudo unzip -o /var/www/html/capiclean.zip -d /var/www/html
sudo cp -rf /var/www/html/html/* /var/www/html/