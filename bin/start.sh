#!/bin/bash

if [ "$1" = "shell" ]; then
/bin/bash
exit 0
fi

if [ ! -d "/app/log" ]; then
mkdir /app/log
fi

if [ ! -d "/run/php" ]; then
mkdir /run/php
fi


if [ ! -d "/app/log/nginx" ]; then
mkdir /app/log/nginx
fi


if [ ! -d "/app/wwwroot" ]; then
mkdir /app/wwwroot
echo "<?php phpinfo(); ?>" > /app/wwwroot/index.php
fi



/usr/sbin/php-fpm7.4 --nodaemonize -c /etc/php/7.4/fpm/php.ini --fpm-config /etc/php/7.4/fpm/php-fpm.conf &

/usr/sbin/nginx -g 'daemon off; master_process on;'
