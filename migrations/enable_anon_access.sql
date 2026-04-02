-- Enable full anon access to all public tables by disabling RLS
-- This gives anonymous users (via anon key) full power to read/write all tables

-- Core tables
ALTER TABLE IF EXISTS public.users DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.branches DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.delivery_service_settings DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.app_icons DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.delivery_settings DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.permissions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_audit_logs DISABLE ROW LEVEL SECURITY;

-- HR & Employee tables
ALTER TABLE IF EXISTS public.hr_employees DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.hr_designation DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.hr_departments DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.hr_fingerprints DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.hr_fingerprint_transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.processed_fingerprint_transactions DISABLE ROW LEVEL SECURITY;

-- Products & Inventory
ALTER TABLE IF EXISTS public.products DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.inventory DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.stock_transactions DISABLE ROW LEVEL SECURITY;

-- Orders & Sales
ALTER TABLE IF EXISTS public.orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.customers DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.invoices DISABLE ROW LEVEL SECURITY;

-- Finance & Accounting
ALTER TABLE IF EXISTS public.transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.accounts DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.ledger_entries DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.petty_cash DISABLE ROW LEVEL SECURITY;

-- Settings & Config
ALTER TABLE IF EXISTS public.system_settings DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.system_api_keys DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.audit_logs DISABLE ROW LEVEL SECURITY;

-- Tables used by views
ALTER TABLE IF EXISTS public.vendors DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.purchases DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.purchase_orders DISABLE ROW LEVEL SECURITY;

-- Disable RLS on all other public schema tables
DO $$ 
DECLARE 
  table_name text;
BEGIN
  FOR table_name IN 
    SELECT tablename FROM pg_tables 
    WHERE schemaname = 'public'
  LOOP
    EXECUTE 'ALTER TABLE IF EXISTS public.' || quote_ident(table_name) || ' DISABLE ROW LEVEL SECURITY';
  END LOOP;
END $$;

-- Grant full permissions to anon-authenticated users
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;
