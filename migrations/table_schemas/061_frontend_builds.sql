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
-- Name: frontend_builds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.frontend_builds (
    id integer NOT NULL,
    version text NOT NULL,
    file_name text NOT NULL,
    file_size bigint DEFAULT 0 NOT NULL,
    storage_path text NOT NULL,
    notes text,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: frontend_builds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.frontend_builds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frontend_builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.frontend_builds_id_seq OWNED BY public.frontend_builds.id;


--
-- Name: frontend_builds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frontend_builds ALTER COLUMN id SET DEFAULT nextval('public.frontend_builds_id_seq'::regclass);


--
-- Name: frontend_builds frontend_builds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frontend_builds
    ADD CONSTRAINT frontend_builds_pkey PRIMARY KEY (id);


--
-- Name: frontend_builds frontend_builds_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frontend_builds
    ADD CONSTRAINT frontend_builds_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);


--
-- Name: frontend_builds Authenticated users can insert frontend_builds; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can insert frontend_builds" ON public.frontend_builds FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: frontend_builds Authenticated users can read frontend_builds; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can read frontend_builds" ON public.frontend_builds FOR SELECT TO authenticated USING (true);


--
-- Name: frontend_builds Service role full access to frontend_builds; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access to frontend_builds" ON public.frontend_builds TO service_role USING (true) WITH CHECK (true);


--
-- Name: frontend_builds; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.frontend_builds ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE frontend_builds; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.frontend_builds TO anon;
GRANT SELECT,INSERT ON TABLE public.frontend_builds TO authenticated;
GRANT ALL ON TABLE public.frontend_builds TO service_role;
GRANT SELECT ON TABLE public.frontend_builds TO replication_user;


--
-- Name: SEQUENCE frontend_builds_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.frontend_builds_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.frontend_builds_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.frontend_builds_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

