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
-- Name: flyer_offer_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyer_offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id uuid NOT NULL,
    product_barcode text NOT NULL,
    cost numeric(10,2),
    sales_price numeric(10,2),
    offer_price numeric(10,2),
    profit_amount numeric(10,2),
    profit_percent numeric(10,2),
    profit_after_offer numeric(10,2),
    decrease_amount numeric(10,2),
    offer_qty integer DEFAULT 1 NOT NULL,
    limit_qty integer,
    free_qty integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    page_number integer DEFAULT 1,
    page_order integer DEFAULT 1,
    total_sales_price numeric DEFAULT 0,
    total_offer_price numeric DEFAULT 0,
    CONSTRAINT flyer_offer_products_free_qty_check CHECK ((free_qty >= 0)),
    CONSTRAINT flyer_offer_products_offer_qty_check CHECK ((offer_qty >= 0))
);


--
-- Name: TABLE flyer_offer_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.flyer_offer_products IS 'Junction table linking flyer offers to products with pricing details';


--
-- Name: COLUMN flyer_offer_products.offer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.offer_id IS 'Reference to the flyer offer';


--
-- Name: COLUMN flyer_offer_products.product_barcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.product_barcode IS 'Reference to the product barcode';


--
-- Name: COLUMN flyer_offer_products.cost; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.cost IS 'Product cost price';


--
-- Name: COLUMN flyer_offer_products.sales_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.sales_price IS 'Regular sales price';


--
-- Name: COLUMN flyer_offer_products.offer_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.offer_price IS 'Special offer price';


--
-- Name: COLUMN flyer_offer_products.profit_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.profit_amount IS 'Profit amount in currency';


--
-- Name: COLUMN flyer_offer_products.profit_percent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.profit_percent IS 'Profit as percentage';


--
-- Name: COLUMN flyer_offer_products.profit_after_offer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.profit_after_offer IS 'Profit after applying offer discount';


--
-- Name: COLUMN flyer_offer_products.decrease_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.decrease_amount IS 'Amount decreased from regular price';


--
-- Name: COLUMN flyer_offer_products.offer_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.offer_qty IS 'Quantity required to qualify for offer';


--
-- Name: COLUMN flyer_offer_products.limit_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.limit_qty IS 'Maximum quantity limit per customer (nullable)';


--
-- Name: COLUMN flyer_offer_products.free_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.free_qty IS 'Free quantity given with purchase';


--
-- Name: COLUMN flyer_offer_products.page_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.page_number IS 'The page number where this product appears in the flyer';


--
-- Name: COLUMN flyer_offer_products.page_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.page_order IS 'The order/position of this product on its page';


--
-- Name: flyer_offer_products flyer_offer_products_offer_id_product_barcode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_offer_id_product_barcode_key UNIQUE (offer_id, product_barcode);


--
-- Name: flyer_offer_products flyer_offer_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_pkey PRIMARY KEY (id);


--
-- Name: idx_flyer_offer_products_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offer_products_barcode ON public.flyer_offer_products USING btree (product_barcode);


--
-- Name: idx_flyer_offer_products_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offer_products_offer_id ON public.flyer_offer_products USING btree (offer_id);


--
-- Name: idx_flyer_offer_products_page; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flyer_offer_products_page ON public.flyer_offer_products USING btree (offer_id, page_number, page_order);


--
-- Name: flyer_offer_products flyer_offer_products_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.flyer_offers(id) ON DELETE CASCADE;


--
-- Name: flyer_offer_products flyer_offer_products_product_barcode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_product_barcode_fkey FOREIGN KEY (product_barcode) REFERENCES public.products(barcode) ON DELETE CASCADE;


--
-- Name: flyer_offer_products Allow anon insert flyer_offer_products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert flyer_offer_products" ON public.flyer_offer_products FOR INSERT TO anon WITH CHECK (true);


--
-- Name: flyer_offer_products allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.flyer_offer_products USING (true) WITH CHECK (true);


--
-- Name: flyer_offer_products allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.flyer_offer_products FOR DELETE USING (true);


--
-- Name: flyer_offer_products allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.flyer_offer_products FOR INSERT WITH CHECK (true);


--
-- Name: flyer_offer_products allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.flyer_offer_products FOR SELECT USING (true);


--
-- Name: flyer_offer_products allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.flyer_offer_products FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: flyer_offer_products anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.flyer_offer_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: flyer_offer_products authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.flyer_offer_products USING ((auth.uid() IS NOT NULL));


--
-- Name: flyer_offer_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.flyer_offer_products ENABLE ROW LEVEL SECURITY;

--
-- Name: flyer_offer_products flyer_offer_products_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offer_products_delete_policy ON public.flyer_offer_products FOR DELETE TO authenticated USING (true);


--
-- Name: flyer_offer_products flyer_offer_products_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offer_products_insert_policy ON public.flyer_offer_products FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: flyer_offer_products flyer_offer_products_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offer_products_select_policy ON public.flyer_offer_products FOR SELECT USING (true);


--
-- Name: POLICY flyer_offer_products_select_policy ON flyer_offer_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY flyer_offer_products_select_policy ON public.flyer_offer_products IS 'Allows public read access to flyer offer products';


--
-- Name: flyer_offer_products flyer_offer_products_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flyer_offer_products_update_policy ON public.flyer_offer_products FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: TABLE flyer_offer_products; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyer_offer_products TO anon;
GRANT SELECT ON TABLE public.flyer_offer_products TO authenticated;
GRANT ALL ON TABLE public.flyer_offer_products TO service_role;
GRANT SELECT ON TABLE public.flyer_offer_products TO replication_user;


--
-- PostgreSQL database dump complete
--

