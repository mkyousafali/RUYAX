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
-- Name: offer_usage_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offer_usage_logs (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    customer_id uuid,
    order_id uuid,
    discount_applied numeric(10,2) NOT NULL,
    original_amount numeric(10,2) NOT NULL,
    final_amount numeric(10,2) NOT NULL,
    cart_items jsonb,
    used_at timestamp with time zone DEFAULT now(),
    session_id character varying(255) DEFAULT NULL::character varying,
    device_type character varying(50) DEFAULT NULL::character varying
);


--
-- Name: TABLE offer_usage_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_usage_logs IS 'Comprehensive logging of all offer applications';


--
-- Name: COLUMN offer_usage_logs.order_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_usage_logs.order_id IS 'Links offer usage to the order where it was applied (NULL for non-order usage)';


--
-- Name: offer_usage_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offer_usage_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_usage_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offer_usage_logs_id_seq OWNED BY public.offer_usage_logs.id;


--
-- Name: offer_usage_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs ALTER COLUMN id SET DEFAULT nextval('public.offer_usage_logs_id_seq'::regclass);


--
-- Name: offer_usage_logs offer_usage_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_pkey PRIMARY KEY (id);


--
-- Name: idx_offer_usage_logs_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offer_usage_logs_customer_id ON public.offer_usage_logs USING btree (customer_id);


--
-- Name: idx_offer_usage_logs_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offer_usage_logs_offer_id ON public.offer_usage_logs USING btree (offer_id);


--
-- Name: idx_offer_usage_logs_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offer_usage_logs_order_id ON public.offer_usage_logs USING btree (order_id);


--
-- Name: idx_offer_usage_logs_order_offer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offer_usage_logs_order_offer ON public.offer_usage_logs USING btree (order_id, offer_id);


--
-- Name: idx_offer_usage_logs_used_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offer_usage_logs_used_at ON public.offer_usage_logs USING btree (used_at DESC);


--
-- Name: offer_usage_logs offer_usage_logs_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: offer_usage_logs offer_usage_logs_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offer_usage_logs Allow anon insert offer_usage_logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert offer_usage_logs" ON public.offer_usage_logs FOR INSERT TO anon WITH CHECK (true);


--
-- Name: offer_usage_logs allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.offer_usage_logs USING (true) WITH CHECK (true);


--
-- Name: offer_usage_logs allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.offer_usage_logs FOR DELETE USING (true);


--
-- Name: offer_usage_logs allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.offer_usage_logs FOR INSERT WITH CHECK (true);


--
-- Name: offer_usage_logs allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.offer_usage_logs FOR SELECT USING (true);


--
-- Name: offer_usage_logs allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.offer_usage_logs FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: offer_usage_logs anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.offer_usage_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: offer_usage_logs authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.offer_usage_logs USING ((auth.uid() IS NOT NULL));


--
-- Name: offer_usage_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_usage_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE offer_usage_logs; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offer_usage_logs TO anon;
GRANT SELECT ON TABLE public.offer_usage_logs TO authenticated;
GRANT ALL ON TABLE public.offer_usage_logs TO service_role;
GRANT SELECT ON TABLE public.offer_usage_logs TO replication_user;


--
-- Name: SEQUENCE offer_usage_logs_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO anon;
GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.offer_usage_logs_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

