--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: wa_catalog_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_catalog_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    catalog_id uuid,
    customer_phone text NOT NULL,
    customer_name text,
    order_status text DEFAULT 'pending'::text,
    items jsonb DEFAULT '[]'::jsonb,
    subtotal numeric(12,2) DEFAULT 0,
    tax numeric(12,2) DEFAULT 0,
    shipping numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    notes text,
    meta_order_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_catalog_orders wa_catalog_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_catalog_orders_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_catalog_orders_account ON public.wa_catalog_orders USING btree (wa_account_id);


--
-- Name: idx_wa_catalog_orders_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_catalog_orders_status ON public.wa_catalog_orders USING btree (order_status);


--
-- Name: wa_catalog_orders wa_catalog_orders_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.wa_catalogs(id);


--
-- Name: wa_catalog_orders wa_catalog_orders_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_catalog_orders Allow authenticated full access on wa_catalog_orders; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated full access on wa_catalog_orders" ON public.wa_catalog_orders TO authenticated USING (true) WITH CHECK (true);


--
-- Name: wa_catalog_orders; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_catalog_orders ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_catalog_orders; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_catalog_orders TO anon;
GRANT ALL ON TABLE public.wa_catalog_orders TO authenticated;
GRANT ALL ON TABLE public.wa_catalog_orders TO service_role;
GRANT SELECT ON TABLE public.wa_catalog_orders TO replication_user;


--
-- PostgreSQL database dump complete
--

