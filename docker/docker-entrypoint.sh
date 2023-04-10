#!/bin/sh

# remove the X-Powered-By header
sed -e "s/expose_php = On/expose_php = Off/g" -i /etc/php81/php.ini

# set php-fpm user to laravel
sed -e "s/user = nobody/user = laravel/g"   -i /etc/php81/php-fpm.d/www.conf
sed -e "s/group = nobody/group = laravel/g" -i /etc/php81/php-fpm.d/www.conf
# enable clear_env = no
sed -e 's/;clear_env = no/clear_env = no/g' -i /etc/php81/php-fpm.d/www.conf

if [ "$LOG_FORMAT" = "proxy" ] ; then
  sed -e "s/access_log \/dev\/stdout main;/access_log \/dev\/stdout $LOG_FORMAT;/g" -i /etc/nginx/http.d/default.conf
fi

# set laravel uid and gid
usermod -u $LARAVEL_USER -g $LARAVEL_USER laravel

# assign laravel a random password
pass=$( N=16 ; cat /dev/urandom | tr -dc A-Za-z0-9 | head -c$N )
printf "%s\n%s\n" $pass $pass | passwd laravel

# start php-fpm
php-fpm81 --allow-to-run-as-root

# create project if /srv/laravel does not exist
if [ ! -d /srv/laravel ] && [ ! -f /srv/laravel ] ; then
  su laravel -c "composer create-project laravel/laravel /srv/laravel"
fi

# display laravel version
cd /srv/laravel; php artisan --version

exec "$@"
