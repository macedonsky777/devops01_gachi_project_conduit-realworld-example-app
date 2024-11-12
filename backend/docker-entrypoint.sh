#!/bin/sh
set -e

# Чекаємо доступність бази даних
until pg_isready -h $DEV_DB_HOSTNAME -p 5432 -U $DEV_DB_USERNAME; do
  echo "Waiting for database connection..."
  sleep 2
done

# Якщо не продакшен - заповнюємо тестовими даними
if [ "$NODE_ENV" != "production" ]; then
  npm run sqlz -- db:seed:all
fi

# Запускаємо команду, яка була передана в аргументах
echo "Starting application with command: $@"
exec "$@"
