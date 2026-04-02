#!/bin/bash
# Run this on Aqura server to import SQL to RUYAX

echo "🚀 Starting import of organized SQL files to RUYAX..."
echo "   Files will be imported in order from SMALLEST to LARGEST"
echo ""

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/01_sets.sql

echo "✓ Stage 1/12 complete: Sets"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/02_schemas.sql

echo "✓ Stage 2/12 complete: Schemas"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/03_types.sql

echo "✓ Stage 3/12 complete: Types"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/04_tables.sql

echo "✓ Stage 4/12 complete: Tables (182 tables created)"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/05_sequences.sql

echo "✓ Stage 5/12 complete: Sequences"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/06_indexes.sql

echo "✓ Stage 6/12 complete: Indexes"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/07_foreign_keys.sql

echo "✓ Stage 7/12 complete: Foreign keys"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/08_triggers.sql

echo "✓ Stage 8/12 complete: Triggers"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/09_functions.sql

echo "✓ Stage 9/12 complete: Functions"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/10_comments.sql

echo "✓ Stage 10/12 complete: Comments"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/11_acl.sql

echo "✓ Stage 11/12 complete: ACL (permissions)"

PGPASSWORD='Alzaidy#123' psql \
  -h db.tncbykfklynsnnyjajgf.supabase.co \
  -p 5432 \
  -d postgres \
  -U postgres \
  -f /tmp/12_other.sql

echo "✓ Stage 12/12 complete: Other"
echo ""
echo "✅ IMPORT COMPLETE!"
echo "🧹 Cleaning up..."
rm -f /tmp/01_sets.sql /tmp/02_schemas.sql /tmp/03_types.sql /tmp/04_tables.sql /tmp/05_sequences.sql /tmp/06_indexes.sql /tmp/07_foreign_keys.sql /tmp/08_triggers.sql /tmp/09_functions.sql /tmp/10_comments.sql /tmp/11_acl.sql /tmp/12_other.sql
echo "✅ Done!"
