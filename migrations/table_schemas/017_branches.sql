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
-- Name: branches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.branches (
    id bigint NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500) NOT NULL,
    location_ar character varying(500) NOT NULL,
    is_active boolean DEFAULT true,
    is_main_branch boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    vat_number character varying(50),
    delivery_service_enabled boolean DEFAULT true NOT NULL,
    pickup_service_enabled boolean DEFAULT true NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00,
    is_24_hours boolean DEFAULT true,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    delivery_message_ar text,
    delivery_message_en text,
    delivery_is_24_hours boolean DEFAULT true,
    delivery_start_time time without time zone,
    delivery_end_time time without time zone,
    pickup_is_24_hours boolean DEFAULT true,
    pickup_start_time time without time zone,
    pickup_end_time time without time zone,
    location_url text,
    latitude double precision,
    longitude double precision,
    CONSTRAINT check_vat_number_not_empty CHECK (((vat_number IS NULL) OR (length(TRIM(BOTH FROM vat_number)) > 0)))
);


--
-- Name: COLUMN branches.vat_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.vat_number IS 'VAT registration number for the branch';


--
-- Name: COLUMN branches.delivery_service_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_service_enabled IS 'Enable/disable delivery service for this branch';


--
-- Name: COLUMN branches.pickup_service_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_service_enabled IS 'Enable/disable store pickup service for this branch';


--
-- Name: COLUMN branches.minimum_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.minimum_order_amount IS 'Minimum order amount for this branch (SAR)';


--
-- Name: COLUMN branches.is_24_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.is_24_hours IS 'Whether delivery service is available 24/7 for this branch';


--
-- Name: COLUMN branches.operating_start_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.operating_start_time IS 'Delivery service start time (if not 24/7)';


--
-- Name: COLUMN branches.operating_end_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.operating_end_time IS 'Delivery service end time (if not 24/7)';


--
-- Name: COLUMN branches.delivery_message_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_message_ar IS 'Custom delivery message in Arabic for this branch';


--
-- Name: COLUMN branches.delivery_message_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_message_en IS 'Custom delivery message in English for this branch';


--
-- Name: COLUMN branches.delivery_is_24_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_is_24_hours IS 'Whether delivery service is available 24/7';


--
-- Name: COLUMN branches.delivery_start_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_start_time IS 'Delivery service start time';


--
-- Name: COLUMN branches.delivery_end_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_end_time IS 'Delivery service end time';


--
-- Name: COLUMN branches.pickup_is_24_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_is_24_hours IS 'Whether pickup service is available 24/7';


--
-- Name: COLUMN branches.pickup_start_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_start_time IS 'Pickup service start time';


--
-- Name: COLUMN branches.pickup_end_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_end_time IS 'Pickup service end time';


--
-- Name: COLUMN branches.location_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.location_url IS 'Google Maps URL for the branch location';


--
-- Name: COLUMN branches.latitude; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.latitude IS 'Branch latitude for distance calculation';


--
-- Name: COLUMN branches.longitude; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.longitude IS 'Branch longitude for distance calculation';


--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: idx_branches_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_branches_active ON public.branches USING btree (is_active);


--
-- Name: idx_branches_main; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_branches_main ON public.branches USING btree (is_main_branch);


--
-- Name: idx_branches_name_ar; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_branches_name_ar ON public.branches USING btree (name_ar);


--
-- Name: idx_branches_name_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_branches_name_en ON public.branches USING btree (name_en);


--
-- Name: idx_branches_vat_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_branches_vat_number ON public.branches USING btree (vat_number) WHERE (vat_number IS NOT NULL);


--
-- Name: branches branches_notify_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER branches_notify_trigger AFTER INSERT OR DELETE OR UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.notify_branches_change();


--
-- Name: branches trigger_update_branches_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_branches_updated_at BEFORE UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.update_branches_updated_at();


--
-- Name: branches allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.branches FOR DELETE USING (true);


--
-- Name: branches allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.branches FOR INSERT WITH CHECK (true);


--
-- Name: branches allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.branches FOR SELECT USING (true);


--
-- Name: branches allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.branches FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: branches; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;

--
-- Name: branches rls_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_delete ON public.branches FOR DELETE USING (true);


--
-- Name: branches rls_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_insert ON public.branches FOR INSERT WITH CHECK (true);


--
-- Name: branches rls_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_select ON public.branches FOR SELECT USING (true);


--
-- Name: branches rls_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY rls_update ON public.branches FOR UPDATE WITH CHECK (true);


--
-- Name: TABLE branches; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.branches TO anon;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.branches TO authenticated;
GRANT ALL ON TABLE public.branches TO service_role;
GRANT SELECT ON TABLE public.branches TO replication_user;


--
-- Name: SEQUENCE branches_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.branches_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.branches_id_seq TO anon;
GRANT ALL ON SEQUENCE public.branches_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.branches_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

