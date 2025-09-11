#!/bin/bash

# Test bot connection by sending a test message to a user
# Usage: ./test_bot.sh <user_id>

if [ -z "$1" ]; then
    echo "Usage: $0 <telegram_user_id>"
    exit 1
fi

USER_ID=$1
ADMIN_TOKEN=$(grep ADMIN_TOKEN .env | cut -d '=' -f2 | tr -d '"')
BASE_URL=$(grep BASE_URL .env | cut -d '=' -f2 | tr -d '"')

if [ -z "$ADMIN_TOKEN" ]; then
    echo "Error: ADMIN_TOKEN not found in .env file"
    exit 1
fi

if [ -z "$BASE_URL" ]; then
    # Use localhost if BASE_URL not set
    BASE_URL="http://localhost:9147"
fi

echo "Testing bot connection..."
echo "User ID: $USER_ID"
echo "Base URL: $BASE_URL"

# Send test message
curl -X POST \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  "${BASE_URL}/admin/test-bot/${USER_ID}" \
  -s | jq .

echo ""
echo "If you see a success response, check your Telegram for the test message."
echo "If not, check the error message above."