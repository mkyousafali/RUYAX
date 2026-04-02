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
-- Name: erp_sync_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.erp_sync_logs (
    id integer NOT NULL,
    sync_type text DEFAULT 'auto'::text NOT NULL,
    branches_total integer DEFAULT 0,
    branches_success integer DEFAULT 0,
    branches_failed integer DEFAULT 0,
    products_fetched integer DEFAULT 0,
    products_inserted integer DEFAULT 0,
    products_updated integer DEFAULT 0,
    duration_ms integer DEFAULT 0,
    details jsonb,
    triggered_by text DEFAULT 'pg_cron'::text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: erp_sync_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.erp_sync_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: erp_sync_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.erp_sync_logs_id_seq OWNED BY public.erp_sync_logs.id;


--
-- Name: erp_sync_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_sync_logs ALTER COLUMN id SET DEFAULT nextval('public.erp_sync_logs_id_seq'::regclass);


--
-- Name: erp_sync_logs erp_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_sync_logs
    ADD CONSTRAINT erp_sync_logs_pkey PRIMARY KEY (id);


--
-- Name: idx_erp_sync_logs_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_erp_sync_logs_created_at ON public.erp_sync_logs USING btree (created_at DESC);


--
-- Name: erp_sync_logs Service role full access on erp_sync_logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on erp_sync_logs" ON public.erp_sync_logs USING (true) WITH CHECK (true);


--
-- Name: erp_sync_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_sync_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE erp_sync_logs; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.erp_sync_logs TO anon;
GRANT SELECT ON TABLE public.erp_sync_logs TO authenticated;
GRANT ALL ON TABLE public.erp_sync_logs TO service_role;
GRANT SELECT ON TABLE public.erp_sync_logs TO replication_user;


--
-- Name: SEQUENCE erp_sync_logs_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.erp_sync_logs_id_seq TO service_role;
GRANT SELECT ON SEQUENCE public.erp_sync_logs_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

