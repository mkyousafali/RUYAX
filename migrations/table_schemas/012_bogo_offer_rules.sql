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
-- Name: bogo_offer_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bogo_offer_rules (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    buy_product_id character varying(50) NOT NULL,
    buy_quantity integer NOT NULL,
    get_product_id character varying(50) NOT NULL,
    get_quantity integer NOT NULL,
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bogo_offer_rules_buy_quantity_check CHECK ((buy_quantity > 0)),
    CONSTRAINT bogo_offer_rules_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('free'::character varying)::text, ('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT bogo_offer_rules_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT bogo_offer_rules_get_quantity_check CHECK ((get_quantity > 0)),
    CONSTRAINT valid_discount_value CHECK ((((discount_type)::text = 'free'::text) OR (((discount_type)::text = 'percentage'::text) AND (discount_value > (0)::numeric) AND (discount_value <= (100)::numeric)) OR (((discount_type)::text = 'amount'::text) AND (discount_value > (0)::numeric))))
);


--
-- Name: TABLE bogo_offer_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.bogo_offer_rules IS 'Stores Buy X Get Y (BOGO) offer rules - each rule defines a condition where buying X product(s) qualifies for discount on Y product(s)';


--
-- Name: COLUMN bogo_offer_rules.buy_product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.buy_product_id IS 'Product customer must buy (X)';


--
-- Name: COLUMN bogo_offer_rules.buy_quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.buy_quantity IS 'Quantity of buy product required';


--
-- Name: COLUMN bogo_offer_rules.get_product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.get_product_id IS 'Product customer gets discount on (Y)';


--
-- Name: COLUMN bogo_offer_rules.get_quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.get_quantity IS 'Quantity of get product that receives discount';


--
-- Name: COLUMN bogo_offer_rules.discount_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.discount_type IS 'Type of discount: free (100% off), percentage (% off), or amount (fixed amount off)';


--
-- Name: COLUMN bogo_offer_rules.discount_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.discount_value IS 'Discount value - 0 for free, 1-100 for percentage, or amount for fixed discount';


--
-- Name: bogo_offer_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bogo_offer_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bogo_offer_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bogo_offer_rules_id_seq OWNED BY public.bogo_offer_rules.id;


--
-- Name: bogo_offer_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules ALTER COLUMN id SET DEFAULT nextval('public.bogo_offer_rules_id_seq'::regclass);


--
-- Name: bogo_offer_rules bogo_offer_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_pkey PRIMARY KEY (id);


--
-- Name: idx_bogo_offer_rules_buy_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bogo_offer_rules_buy_product ON public.bogo_offer_rules USING btree (buy_product_id);


--
-- Name: idx_bogo_offer_rules_buy_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bogo_offer_rules_buy_product_id ON public.bogo_offer_rules USING btree (buy_product_id);


--
-- Name: idx_bogo_offer_rules_get_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bogo_offer_rules_get_product ON public.bogo_offer_rules USING btree (get_product_id);


--
-- Name: idx_bogo_offer_rules_get_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bogo_offer_rules_get_product_id ON public.bogo_offer_rules USING btree (get_product_id);


--
-- Name: idx_bogo_offer_rules_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bogo_offer_rules_offer_id ON public.bogo_offer_rules USING btree (offer_id);


--
-- Name: bogo_offer_rules trigger_update_bogo_offer_rules_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_bogo_offer_rules_updated_at BEFORE UPDATE ON public.bogo_offer_rules FOR EACH ROW EXECUTE FUNCTION public.update_bogo_offer_rules_updated_at();


--
-- Name: bogo_offer_rules bogo_offer_rules_buy_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_buy_product_id_fkey FOREIGN KEY (buy_product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: bogo_offer_rules bogo_offer_rules_get_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_get_product_id_fkey FOREIGN KEY (get_product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: bogo_offer_rules bogo_offer_rules_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: bogo_offer_rules Allow anon insert bogo_offer_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert bogo_offer_rules" ON public.bogo_offer_rules FOR INSERT TO anon WITH CHECK (true);


--
-- Name: bogo_offer_rules Allow read access to bogo_offer_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow read access to bogo_offer_rules" ON public.bogo_offer_rules FOR SELECT TO authenticated USING (true);


--
-- Name: bogo_offer_rules Allow service role full access to bogo_offer_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role full access to bogo_offer_rules" ON public.bogo_offer_rules TO service_role USING (true) WITH CHECK (true);


--
-- Name: bogo_offer_rules allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.bogo_offer_rules USING (true) WITH CHECK (true);


--
-- Name: bogo_offer_rules allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.bogo_offer_rules FOR DELETE USING (true);


--
-- Name: bogo_offer_rules allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.bogo_offer_rules FOR INSERT WITH CHECK (true);


--
-- Name: bogo_offer_rules allow_public_read_bogo; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_public_read_bogo ON public.bogo_offer_rules FOR SELECT TO authenticated, anon USING (true);


--
-- Name: bogo_offer_rules allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.bogo_offer_rules FOR SELECT USING (true);


--
-- Name: bogo_offer_rules allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.bogo_offer_rules FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: bogo_offer_rules anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.bogo_offer_rules USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: bogo_offer_rules authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.bogo_offer_rules USING ((auth.uid() IS NOT NULL));


--
-- Name: bogo_offer_rules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bogo_offer_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE bogo_offer_rules; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.bogo_offer_rules TO anon;
GRANT SELECT ON TABLE public.bogo_offer_rules TO authenticated;
GRANT ALL ON TABLE public.bogo_offer_rules TO service_role;
GRANT SELECT ON TABLE public.bogo_offer_rules TO replication_user;


--
-- Name: SEQUENCE bogo_offer_rules_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO anon;
GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.bogo_offer_rules_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

