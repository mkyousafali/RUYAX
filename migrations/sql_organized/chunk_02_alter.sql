-- chunk_02_alter.sql

v_columns := v_columns || 'ALTER TABLE public.' || quote_ident(r.table_name) || ' ADD COLUMN IF NOT EXISTS ' || quote_ident(col.attname) || ' ' || col.col_type;

IF rls_enabled THEN
      ddl := ddl || E'\n\n' || 'ALTER TABLE public.' || quote_ident(rec.tname) || ' ENABLE ROW LEVEL SECURITY;';

ALTER TABLE ONLY public.break_register REPLICA IDENTITY FULL;

ALTER TABLE ONLY public.delivery_service_settings REPLICA IDENTITY FULL;

ALTER TABLE ONLY public.order_audit_logs REPLICA IDENTITY FULL;

ALTER TABLE ONLY public.order_items REPLICA IDENTITY FULL;

ALTER TABLE ONLY public.orders REPLICA IDENTITY FULL;

ALTER TABLE ONLY public.wa_broadcast_recipients REPLICA IDENTITY FULL;

ALTER TABLE ONLY public.wa_broadcasts REPLICA IDENTITY FULL;