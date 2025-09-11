#!/bin/bash

# Database connection parameters
export PGPASSWORD='ooaK3Wj4XLW9x&bXfRRv##'
DB_HOST="192.168.110.68"
DB_PORT="5432"
DB_NAME="sufeshopbot"
DB_USER="sufeshopbot"

echo "=== Fixing message_templates table constraint ==="
echo

# Function to run psql command
run_psql() {
    docker run --rm -e PGPASSWORD postgres:alpine psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "$1"
}

# Function to run psql command and capture output
run_psql_query() {
    docker run --rm -e PGPASSWORD postgres:alpine psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "$1"
}

echo "1. Checking current indexes on message_templates table:"
run_psql "\di message_templates"
echo

echo "2. Dropping old unique constraint 'idx_message_templates_code' (if exists)..."
run_psql "DROP INDEX IF EXISTS idx_message_templates_code;"
echo "   ✓ Old constraint dropped (or didn't exist)"
echo

echo "3. Checking if composite index 'idx_code_lang' already exists..."
EXISTS=$(run_psql_query "SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'message_templates' AND indexname = 'idx_code_lang' AND schemaname = 'public';" | tr -d ' ')

if [ "$EXISTS" -gt "0" ]; then
    echo "   ✓ Composite index 'idx_code_lang' already exists!"
else
    echo "   Creating new composite unique index 'idx_code_lang' on (code, language)..."
    run_psql "CREATE UNIQUE INDEX idx_code_lang ON message_templates (code, language);"
    echo "   ✓ New composite index created successfully!"
fi
echo

echo "4. Verifying final indexes on message_templates table:"
run_psql "\di message_templates"
echo

echo "5. Checking for duplicate (code, language) combinations..."
DUPLICATES=$(run_psql_query "SELECT COUNT(*) FROM (SELECT code, language, COUNT(*) as count FROM message_templates GROUP BY code, language HAVING COUNT(*) > 1) as dups;" | tr -d ' ')

if [ "$DUPLICATES" -gt "0" ]; then
    echo "   ⚠ WARNING: Found duplicate (code, language) combinations:"
    run_psql "SELECT code, language, COUNT(*) as count FROM message_templates GROUP BY code, language HAVING COUNT(*) > 1;"
    echo "   You may need to resolve these duplicates."
else
    echo "   ✓ No duplicate (code, language) combinations found!"
fi
echo

echo "✅ Constraint fix completed successfully!"