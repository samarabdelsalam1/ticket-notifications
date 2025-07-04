#!/bin/bash

# until mysql -h ticket-notification_development_db -u ${DEVELOPMENT_DB_USERNAME} -p${DEVELOPMENT_DB_PASSWORD} -e "SELECT 1"; do
#   echo "Waiting for database to be ready..."
#   sleep 5
# done

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
echo "Running bundle install..."
bundle install

echo "Running migrations..."
rails db:migrate

echo "Starting server..."
exec "$@"