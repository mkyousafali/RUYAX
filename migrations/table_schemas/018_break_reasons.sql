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
-- Name: break_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.break_reasons (
    id integer NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    requires_note boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: break_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.break_reasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: break_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.break_reasons_id_seq OWNED BY public.break_reasons.id;


--
-- Name: break_reasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_reasons ALTER COLUMN id SET DEFAULT nextval('public.break_reasons_id_seq'::regclass);


--
-- Name: break_reasons break_reasons_name_en_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_reasons
    ADD CONSTRAINT break_reasons_name_en_unique UNIQUE (name_en);


--
-- Name: break_reasons break_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_reasons
    ADD CONSTRAINT break_reasons_pkey PRIMARY KEY (id);


--
-- Name: break_reasons Allow all access to break_reasons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to break_reasons" ON public.break_reasons USING (true) WITH CHECK (true);


--
-- Name: break_reasons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.break_reasons ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE break_reasons; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.break_reasons TO anon;
GRANT ALL ON TABLE public.break_reasons TO authenticated;
GRANT ALL ON TABLE public.break_reasons TO service_role;
GRANT SELECT ON TABLE public.break_reasons TO replication_user;


--
-- Name: SEQUENCE break_reasons_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.break_reasons_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.break_reasons_id_seq TO authenticated;


--
-- PostgreSQL database dump complete
--

