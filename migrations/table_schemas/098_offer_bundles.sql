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
-- Name: offer_bundles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offer_bundles (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    bundle_name_ar character varying(255) NOT NULL,
    bundle_name_en character varying(255) NOT NULL,
    required_products jsonb NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    discount_type character varying(20) DEFAULT 'amount'::character varying,
    CONSTRAINT offer_bundles_discount_amount_check CHECK ((discount_value > (0)::numeric)),
    CONSTRAINT offer_bundles_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT offer_bundles_discount_value_check CHECK ((discount_value > (0)::numeric))
);


--
-- Name: TABLE offer_bundles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_bundles IS 'Bundle offer configurations with multiple products';


--
-- Name: offer_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offer_bundles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offer_bundles_id_seq OWNED BY public.offer_bundles.id;


--
-- Name: offer_bundles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_bundles ALTER COLUMN id SET DEFAULT nextval('public.offer_bundles_id_seq'::regclass);


--
-- Name: offer_bundles offer_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_bundles
    ADD CONSTRAINT offer_bundles_pkey PRIMARY KEY (id);


--
-- Name: idx_offer_bundles_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offer_bundles_offer_id ON public.offer_bundles USING btree (offer_id);


--
-- Name: offer_bundles trigger_update_offer_bundles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_offer_bundles_updated_at BEFORE UPDATE ON public.offer_bundles FOR EACH ROW EXECUTE FUNCTION public.update_offers_updated_at();


--
-- Name: offer_bundles trigger_validate_bundle_offer_type; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_validate_bundle_offer_type BEFORE INSERT OR UPDATE ON public.offer_bundles FOR EACH ROW EXECUTE FUNCTION public.validate_bundle_offer_type();


--
-- Name: offer_bundles offer_bundles_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_bundles
    ADD CONSTRAINT offer_bundles_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offer_bundles Allow anon insert offer_bundles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert offer_bundles" ON public.offer_bundles FOR INSERT TO anon WITH CHECK (true);


--
-- Name: offer_bundles allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.offer_bundles USING (true) WITH CHECK (true);


--
-- Name: offer_bundles allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.offer_bundles FOR DELETE USING (true);


--
-- Name: offer_bundles allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.offer_bundles FOR INSERT WITH CHECK (true);


--
-- Name: offer_bundles allow_public_read_bundles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_public_read_bundles ON public.offer_bundles FOR SELECT TO authenticated, anon USING (true);


--
-- Name: offer_bundles allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.offer_bundles FOR SELECT USING (true);


--
-- Name: offer_bundles allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.offer_bundles FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: offer_bundles anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.offer_bundles USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: offer_bundles authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.offer_bundles USING ((auth.uid() IS NOT NULL));


--
-- Name: offer_bundles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_bundles ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE offer_bundles; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offer_bundles TO anon;
GRANT SELECT ON TABLE public.offer_bundles TO authenticated;
GRANT ALL ON TABLE public.offer_bundles TO service_role;
GRANT SELECT ON TABLE public.offer_bundles TO replication_user;


--
-- Name: SEQUENCE offer_bundles_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO anon;
GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.offer_bundles_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

