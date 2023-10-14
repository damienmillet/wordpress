#!/bin/sh

if [ ! -f /var/www/localhost/htdocs/wordpress/wp-config.php ]; then
  openrc && touch /run/openrc/softlevel
  rc-update add php-fpm$(apk info | grep -E 'php\d.?-fpm' | sed 's/[^0-9]*//g') default
  rc-update add nginx default
  rc-update add mariadb default
  rc-service mariadb setup
  rc-service mariadb start
  mysql < base.sql
  rc-service php-fpm$(apk info | grep -E 'php\d.?-fpm' | sed 's/[^0-9]*//g') start
  rc-service nginx start
  rm base.sql
  wget -c https://wordpress.org/latest.tar.gz -O - | tar -xz -C /var/www/localhost/htdocs/
  cp /var/www/localhost/htdocs/wordpress/wp-config-sample.php /var/www/localhost/htdocs/wordpress/wp-config.php
  sed -i 's/database_name_here/wordpress/g' /var/www/localhost/htdocs/wordpress/wp-config.php
  sed -i 's/username_here/wordpress/g' /var/www/localhost/htdocs/wordpress/wp-config.php
  sed -i 's/password_here/password/g' /var/www/localhost/htdocs/wordpress/wp-config.php
  chown -R root:www-data /var/www/
  wget --post-data="weblog_title=Blog+de+Test&user_name=demo&admin_password=demo&admin_password2=demo&pw_weak=on&admin_email=demo%40demo.fr&Submit=Installer+WordPress" http://localhost/wp-admin/install.php?step=2 -O /dev/null
  if [ -n "$PORT" ]; then
    echo "define( 'WP_HOME', 'http://localhost:$PORT' );" >> /var/www/localhost/htdocs/wordpress/wp-config.php
    echo "define( 'WP_SITEURL', 'http://localhost:$PORT' );" >> /var/www/localhost/htdocs/wordpress/wp-config.php
  fi
fi

if [ -n "$RSYSLOG_HOST" ]; then
  if [ ! -f /etc/rsyslog.conf ]; then
    apk add rsyslog --no-cache
    rc-update add rsyslog boot
    sed -i '/^#/d' /etc/rsyslog.conf
    sed -i '/^$/d' /etc/rsyslog.conf
    echo '#' >> /etc/rsyslog.conf
  fi
  echo "*.* @$RSYSLOG_HOST:514" >> /etc/rsyslog.conf
  rc-service rsyslog restart
fi

while true; do
  sleep 1000
done
