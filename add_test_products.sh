#!/bin/bash

# 添加测试产品数据的脚本

echo "开始添加测试产品数据..."

# 获取管理员token（假设使用默认的test token）
TOKEN="test"

# 基础URL
BASE_URL="http://localhost:9147/admin"

# 使用cookie认证
COOKIE="admin_token=$TOKEN"

# 添加几个测试产品
echo "1. 添加 Azure账号..."
curl -s -X POST "$BASE_URL/products" \
  -H "Cookie: $COOKIE" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Azure FT US Outlook",
    "description": "Azure免费试用账号，包含200美元额度",
    "price_cents": 4500
  }' | jq .

echo "2. 添加 AWS账号..."
curl -s -X POST "$BASE_URL/products" \
  -H "Cookie: $COOKIE" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "AWS Free Tier",
    "description": "AWS免费套餐账号，包含12个月免费服务",
    "price_cents": 3800
  }' | jq .

echo "3. 添加 Google Cloud账号..."
curl -s -X POST "$BASE_URL/products" \
  -H "Cookie: $COOKIE" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Google Cloud Platform",
    "description": "GCP新用户账号，包含300美元赠金",
    "price_cents": 5200
  }' | jq .

echo "4. 添加 ChatGPT Plus账号..."
curl -s -X POST "$BASE_URL/products" \
  -H "Cookie: $COOKIE" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ChatGPT Plus月卡",
    "description": "ChatGPT Plus会员账号，有效期30天",
    "price_cents": 15800
  }' | jq .

echo "完成！正在获取产品列表..."
curl -s "$BASE_URL/products" \
  -H "Cookie: $COOKIE" \
  -H "Accept: application/json" | jq .