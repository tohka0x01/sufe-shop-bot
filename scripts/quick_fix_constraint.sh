#!/bin/bash
# Single command to fix the constraint using Docker and PostgreSQL

docker run --rm -it \
  -e PGPASSWORD='ooaK3Wj4XLW9x&bXfRRv##' \
  postgres:alpine \
  psql -h 192.168.110.68 -p 5432 -U sufeshopbot -d sufeshopbot -c "
    -- Drop old constraint
    DROP INDEX IF EXISTS idx_message_templates_code;
    
    -- Create new composite constraint
    CREATE UNIQUE INDEX IF NOT EXISTS idx_code_lang ON message_templates (code, language);
    
    -- Show final indexes
    SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'message_templates';
  "