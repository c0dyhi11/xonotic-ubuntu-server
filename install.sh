#!/bin/bash
# Create A and AAAA DNS records for $FQDN
FQDN='xonotic.codyhill.co'
EMAIL='webmaster@example.com'
DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -o Dpkg::Options::="--force-confold" --force-yes -y
DEBIAN_FRONTEND=noninteractive apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y unzip nginx python-certbot-nginx
wget https://dl.xonotic.org/xonotic-0.8.2.zip
adduser --disabled-password --gecos "" xonotic
su xonotic -c 'mkdir -p /home/xonotic/.xonotic/data'
unzip xonotic-0.8.2.zip 
mv Xonotic/ /srv/
chown -R xonotic /srv/Xonotic/
curl -Lo /var/www/html/index.html https://raw.githubusercontent.com/c0dyhi11/xonotic-ubuntu-server/master/configs/index.html
curl -Lo /lib/systemd/system/xonotic.service https://raw.githubusercontent.com/c0dyhi11/xonotic-ubuntu-server/master/configs/xonotic.service
curl -Lo /home/xonotic/.xonotic/data/server.cfg https://raw.githubusercontent.com/c0dyhi11/xonotic-ubuntu-server/master/configs/server.cfg
cp /home/xonotic/.xonotic/data/server.cfg /home/xonotic/.xonotic/
chown -R xonotic /home/xonotic/.xonotic/
systemctl daemon-reload
systemctl enable nginx
systemctl enable xonotic
systemctl start xonotic
certbot --nginx -d $FQDN --non-interactive --agree-tos -m $EMAIL --redirect 
rm -rf /var/www/html/index.nginx-debian.html 
mv xonotic-0.8.2.zip /var/www/html/
# For some reason this folder exists and CertBot fails to renew if it does.
rm -rf /run/systemd/system/

