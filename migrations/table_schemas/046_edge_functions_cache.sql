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
-- Name: edge_functions_cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edge_functions_cache (
    func_name text NOT NULL,
    func_size text,
    file_count integer DEFAULT 0,
    last_modified timestamp with time zone,
    has_index boolean DEFAULT false,
    func_code text DEFAULT ''::text,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: edge_functions_cache edge_functions_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edge_functions_cache
    ADD CONSTRAINT edge_functions_cache_pkey PRIMARY KEY (func_name);


--
-- Name: TABLE edge_functions_cache; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.edge_functions_cache TO anon;
GRANT SELECT ON TABLE public.edge_functions_cache TO authenticated;
GRANT ALL ON TABLE public.edge_functions_cache TO service_role;
GRANT SELECT ON TABLE public.edge_functions_cache TO replication_user;


--
-- PostgreSQL database dump complete
--

