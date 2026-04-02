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
-- Name: break_security_seed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.break_security_seed (
    id integer DEFAULT 1 NOT NULL,
    seed text DEFAULT encode(extensions.gen_random_bytes(32), 'hex'::text) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_security_seed_id_check CHECK ((id = 1))
);


--
-- Name: break_security_seed break_security_seed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_security_seed
    ADD CONSTRAINT break_security_seed_pkey PRIMARY KEY (id);


--
-- Name: break_security_seed; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.break_security_seed ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE break_security_seed; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.break_security_seed TO anon;
GRANT SELECT ON TABLE public.break_security_seed TO authenticated;
GRANT ALL ON TABLE public.break_security_seed TO service_role;
GRANT SELECT ON TABLE public.break_security_seed TO replication_user;


--
-- PostgreSQL database dump complete
--

