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
-- Name: wa_catalog_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_catalog_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    catalog_id uuid NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_product_id text,
    retailer_id text,
    name text NOT NULL,
    description text,
    price numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    sale_price numeric(12,2),
    image_url text,
    additional_images text[] DEFAULT '{}'::text[],
    url text,
    category text,
    availability text DEFAULT 'in stock'::text,
    condition text DEFAULT 'new'::text,
    brand text,
    sku text,
    quantity integer DEFAULT 0,
    is_hidden boolean DEFAULT false,
    status text DEFAULT 'active'::text,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_catalog_products wa_catalog_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_catalog_products_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_catalog_products_account ON public.wa_catalog_products USING btree (wa_account_id);


--
-- Name: idx_wa_catalog_products_catalog; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_catalog_products_catalog ON public.wa_catalog_products USING btree (catalog_id);


--
-- Name: idx_wa_catalog_products_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_catalog_products_sku ON public.wa_catalog_products USING btree (sku);


--
-- Name: wa_catalog_products wa_catalog_products_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.wa_catalogs(id) ON DELETE CASCADE;


--
-- Name: wa_catalog_products wa_catalog_products_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_catalog_products Allow authenticated full access on wa_catalog_products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated full access on wa_catalog_products" ON public.wa_catalog_products TO authenticated USING (true) WITH CHECK (true);


--
-- Name: wa_catalog_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_catalog_products ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_catalog_products; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_catalog_products TO anon;
GRANT ALL ON TABLE public.wa_catalog_products TO authenticated;
GRANT ALL ON TABLE public.wa_catalog_products TO service_role;
GRANT SELECT ON TABLE public.wa_catalog_products TO replication_user;


--
-- PostgreSQL database dump complete
--

