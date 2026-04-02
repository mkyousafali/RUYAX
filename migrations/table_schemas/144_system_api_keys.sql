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
-- Name: system_api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_api_keys (
    id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    api_key text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: system_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.system_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_api_keys_id_seq OWNED BY public.system_api_keys.id;


--
-- Name: system_api_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_api_keys ALTER COLUMN id SET DEFAULT nextval('public.system_api_keys_id_seq'::regclass);


--
-- Name: system_api_keys system_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_api_keys
    ADD CONSTRAINT system_api_keys_pkey PRIMARY KEY (id);


--
-- Name: system_api_keys system_api_keys_service_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_api_keys
    ADD CONSTRAINT system_api_keys_service_name_key UNIQUE (service_name);


--
-- Name: idx_system_api_keys_service_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_system_api_keys_service_name ON public.system_api_keys USING btree (service_name);


--
-- Name: system_api_keys system_api_keys_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER system_api_keys_timestamp_update BEFORE UPDATE ON public.system_api_keys FOR EACH ROW EXECUTE FUNCTION public.update_system_api_keys_timestamp();


--
-- Name: system_api_keys Enable all access to system_api_keys; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable all access to system_api_keys" ON public.system_api_keys USING (true) WITH CHECK (true);


--
-- Name: system_api_keys; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.system_api_keys ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE system_api_keys; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.system_api_keys TO anon;
GRANT ALL ON TABLE public.system_api_keys TO authenticated;
GRANT ALL ON TABLE public.system_api_keys TO service_role;
GRANT SELECT ON TABLE public.system_api_keys TO replication_user;


--
-- Name: SEQUENCE system_api_keys_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.system_api_keys_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.system_api_keys_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.system_api_keys_id_seq TO anon;


--
-- PostgreSQL database dump complete
--

