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
-- Name: offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offers (
    id integer NOT NULL,
    type character varying(20) NOT NULL,
    name_ar character varying(255) NOT NULL,
    name_en character varying(255) NOT NULL,
    description_ar text,
    description_en text,
    start_date timestamp with time zone DEFAULT now() NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    max_uses_per_customer integer,
    max_total_uses integer,
    current_total_uses integer DEFAULT 0,
    branch_id integer,
    service_type character varying(20) DEFAULT 'both'::character varying,
    show_on_product_page boolean DEFAULT true,
    show_in_carousel boolean DEFAULT false,
    send_push_notification boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offers_service_type_check CHECK (((service_type)::text = ANY (ARRAY[('delivery'::character varying)::text, ('pickup'::character varying)::text, ('both'::character varying)::text]))),
    CONSTRAINT offers_type_check CHECK (((type)::text = ANY (ARRAY[('bundle'::character varying)::text, ('cart'::character varying)::text, ('product'::character varying)::text, ('bogo'::character varying)::text]))),
    CONSTRAINT valid_date_range CHECK ((end_date > start_date))
);


--
-- Name: TABLE offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offers IS 'Main offers table with all offer configurations and rules';


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offers_id_seq OWNED BY public.offers.id;


--
-- Name: offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers ALTER COLUMN id SET DEFAULT nextval('public.offers_id_seq'::regclass);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: idx_offers_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_branch_id ON public.offers USING btree (branch_id);


--
-- Name: idx_offers_date_range; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_date_range ON public.offers USING btree (start_date, end_date);


--
-- Name: idx_offers_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_is_active ON public.offers USING btree (is_active);


--
-- Name: idx_offers_service_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_service_type ON public.offers USING btree (service_type);


--
-- Name: idx_offers_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_type ON public.offers USING btree (type);


--
-- Name: offers trigger_update_offers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_offers_updated_at BEFORE UPDATE ON public.offers FOR EACH ROW EXECUTE FUNCTION public.update_offers_updated_at();


--
-- Name: offers offers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: offers offers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: offers allow_delete_offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete_offers ON public.offers FOR DELETE USING (true);


--
-- Name: offers allow_insert_offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert_offers ON public.offers FOR INSERT WITH CHECK (true);


--
-- Name: offers allow_select_offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select_offers ON public.offers FOR SELECT USING (true);


--
-- Name: offers allow_update_offers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update_offers ON public.offers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: offers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offers ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE offers; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offers TO anon;
GRANT SELECT ON TABLE public.offers TO authenticated;
GRANT ALL ON TABLE public.offers TO service_role;
GRANT SELECT ON TABLE public.offers TO replication_user;


--
-- Name: SEQUENCE offers_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.offers_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.offers_id_seq TO anon;
GRANT ALL ON SEQUENCE public.offers_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.offers_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

