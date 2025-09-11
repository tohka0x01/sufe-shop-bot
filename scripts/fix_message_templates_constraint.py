#!/usr/bin/env python3
"""
Fix message_templates table constraint in PostgreSQL
Drops the old unique constraint on 'code' and creates a composite unique constraint on (code, language)
"""

import psycopg2
from psycopg2 import sql
import sys

# Database connection parameters
DB_CONFIG = {
    'host': '192.168.110.68',
    'port': 5432,
    'database': 'sufeshopbot',
    'user': 'sufeshopbot',
    'password': 'ooaK3Wj4XLW9x&bXfRRv##'
}

def main():
    conn = None
    cur = None
    
    try:
        # Connect to PostgreSQL
        print("Connecting to PostgreSQL database...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        print("Connected successfully!")
        
        # Step 1: Check current indexes on message_templates
        print("\n1. Checking current indexes on message_templates table:")
        cur.execute("""
            SELECT indexname, indexdef 
            FROM pg_indexes 
            WHERE tablename = 'message_templates' 
            AND schemaname = 'public'
        """)
        
        indexes = cur.fetchall()
        for idx_name, idx_def in indexes:
            print(f"   - {idx_name}: {idx_def}")
        
        # Step 2: Drop the old unique constraint
        print("\n2. Dropping old unique constraint 'idx_message_templates_code' (if exists)...")
        try:
            cur.execute("DROP INDEX IF EXISTS idx_message_templates_code")
            conn.commit()
            print("   ✓ Old constraint dropped successfully (or didn't exist)")
        except Exception as e:
            print(f"   ⚠ Warning: {e}")
            conn.rollback()
        
        # Step 3: Check if the new composite index already exists
        print("\n3. Checking if composite index 'idx_code_lang' already exists...")
        cur.execute("""
            SELECT COUNT(*) 
            FROM pg_indexes 
            WHERE tablename = 'message_templates' 
            AND indexname = 'idx_code_lang'
            AND schemaname = 'public'
        """)
        
        exists = cur.fetchone()[0] > 0
        
        if exists:
            print("   ✓ Composite index 'idx_code_lang' already exists!")
        else:
            # Create new composite unique index
            print("   Creating new composite unique index 'idx_code_lang' on (code, language)...")
            try:
                cur.execute("CREATE UNIQUE INDEX idx_code_lang ON message_templates (code, language)")
                conn.commit()
                print("   ✓ New composite index created successfully!")
            except Exception as e:
                print(f"   ✗ Error creating index: {e}")
                conn.rollback()
                raise
        
        # Step 4: Verify the changes
        print("\n4. Verifying final indexes on message_templates table:")
        cur.execute("""
            SELECT indexname, indexdef 
            FROM pg_indexes 
            WHERE tablename = 'message_templates' 
            AND schemaname = 'public'
        """)
        
        indexes = cur.fetchall()
        for idx_name, idx_def in indexes:
            print(f"   - {idx_name}: {idx_def}")
        
        # Step 5: Check for duplicate (code, language) combinations
        print("\n5. Checking for duplicate (code, language) combinations...")
        cur.execute("""
            SELECT code, language, COUNT(*) as count
            FROM message_templates
            GROUP BY code, language
            HAVING COUNT(*) > 1
        """)
        
        duplicates = cur.fetchall()
        if duplicates:
            print("   ⚠ WARNING: Found duplicate (code, language) combinations:")
            for code, lang, count in duplicates:
                print(f"     - Code: '{code}', Language: '{lang}', Count: {count}")
            print("   You may need to resolve these duplicates.")
        else:
            print("   ✓ No duplicate (code, language) combinations found!")
        
        print("\n✅ Constraint fix completed successfully!")
        
    except psycopg2.Error as e:
        print(f"\n✗ Database error: {e}")
        if conn:
            conn.rollback()
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Unexpected error: {e}")
        sys.exit(1)
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()
            print("\nDatabase connection closed.")

if __name__ == "__main__":
    main()