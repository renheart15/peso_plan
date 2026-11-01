#!/bin/sh
set -e

php artisan config:clear
php artisan migrate --force
php artisan config:cache

exec apache2-foreground
