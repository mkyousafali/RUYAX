#!/bin/bash

# Export all tables needed for users data import
echo "Exporting dependent tables for users..."

docker exec supabase-db pg_dump -U supabase_admin -d postgres -t public.hr_employees --data-only --inserts > /tmp/hr_employees_data.sql
docker exec supabase-db pg_dump -U supabase_admin -d postgres -t public.roles --data-only --inserts > /tmp/roles_data.sql
docker exec supabase-db pg_dump -U supabase_admin -d postgres -t public.permissions --data-only --inserts > /tmp/permissions_data.sql

echo "All tables exported successfully"
