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
-- Name: denomination_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.denomination_types (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    value numeric(10,2) NOT NULL,
    label character varying(50) NOT NULL,
    label_ar character varying(50),
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE denomination_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_types IS 'Master table for denomination types (currency notes, coins, damage)';


--
-- Name: denomination_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.denomination_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: denomination_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.denomination_types_id_seq OWNED BY public.denomination_types.id;


--
-- Name: denomination_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_types ALTER COLUMN id SET DEFAULT nextval('public.denomination_types_id_seq'::regclass);


--
-- Name: denomination_types denomination_types_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_types
    ADD CONSTRAINT denomination_types_code_key UNIQUE (code);


--
-- Name: denomination_types denomination_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_types
    ADD CONSTRAINT denomination_types_pkey PRIMARY KEY (id);


--
-- Name: idx_denomination_types_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_denomination_types_active ON public.denomination_types USING btree (is_active, sort_order);


--
-- Name: denomination_types denomination_types_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER denomination_types_updated_at BEFORE UPDATE ON public.denomination_types FOR EACH ROW EXECUTE FUNCTION public.update_denomination_updated_at();


--
-- Name: denomination_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_types ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_types denomination_types_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_types_delete ON public.denomination_types FOR DELETE USING (true);


--
-- Name: denomination_types denomination_types_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_types_insert ON public.denomination_types FOR INSERT WITH CHECK (true);


--
-- Name: denomination_types denomination_types_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_types_select ON public.denomination_types FOR SELECT USING (true);


--
-- Name: denomination_types denomination_types_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY denomination_types_update ON public.denomination_types FOR UPDATE USING (true);


--
-- Name: TABLE denomination_types; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.denomination_types TO anon;
GRANT ALL ON TABLE public.denomination_types TO authenticated;
GRANT ALL ON TABLE public.denomination_types TO service_role;
GRANT SELECT ON TABLE public.denomination_types TO replication_user;


--
-- Name: SEQUENCE denomination_types_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.denomination_types_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.denomination_types_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.denomination_types_id_seq TO anon;
GRANT SELECT ON SEQUENCE public.denomination_types_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

