#!/bin/bash

until mysqladmin ping -h"$LARAVEL_DATABASE_HOST" -P"$LARAVEL_DATABASE_PORT_NUMBER" -u"$LARAVEL_DATABASE_USER" -p"$LARAVEL_DATABASE_PASSWORD" --silent; do
  echo "Waiting for database..."
  sleep 5
done

echo "Database is ready."

if [ ! -f .env ]; then
  echo ".env not found"
  if [ "$APP_ENV" = "local" ] && [ -f .env.develop ]; then
    echo "Creating .env from .env.develop"
    cp .env.develop .env
  else
    echo "Creating .env from .env.production"
    cp .env.production .env
  fi
  # php artisan key:generate
  # php artisan jwt:secret --force
else
  echo ".env already exists"
fi

php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

php artisan migrate --force
apache2-foreground
