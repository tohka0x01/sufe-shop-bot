#!/bin/bash

# Database connection parameters
DB_HOST="192.168.110.68"
DB_PORT="5432"
DB_NAME="sufeshopbot"
DB_USER="sufeshopbot"
DB_PASS='ooaK3Wj4XLW9x&bXfRRv##'

echo "Executing SQL commands to fix message_templates constraint..."
echo
echo "Connection details:"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo

# Execute the SQL script using docker
docker run --rm \
  -e PGPASSWORD="$DB_PASS" \
  -v /data/sufe/shop-bot/scripts:/scripts:ro \
  postgres:alpine \
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f /scripts/fix_message_templates_constraint.sql

echo
echo "Done! Check the output above for results."