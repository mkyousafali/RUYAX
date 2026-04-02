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
-- Name: biometric_connections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.biometric_connections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    device_id text NOT NULL,
    terminal_sn text,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_employee_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_location_code text
);


--
-- Name: TABLE biometric_connections; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.biometric_connections IS 'Stores biometric server connection configurations for ZKBioTime attendance sync';


--
-- Name: COLUMN biometric_connections.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.branch_id IS 'References branches.id - which Ruyax branch this config belongs to';


--
-- Name: COLUMN biometric_connections.server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.server_ip IS 'IP address of ZKBioTime SQL Server (e.g., 192.168.0.3)';


--
-- Name: COLUMN biometric_connections.server_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.server_name IS 'SQL Server instance name (e.g., SQLEXPRESS, WIN-D1D6EN8240A)';


--
-- Name: COLUMN biometric_connections.database_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.database_name IS 'ZKBioTime database name (e.g., Zkurbard)';


--
-- Name: COLUMN biometric_connections.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.device_id IS 'Computer name/ID running the sync app';


--
-- Name: COLUMN biometric_connections.terminal_sn; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.terminal_sn IS 'Optional: Filter by specific terminal serial number (e.g., MFP3243700773)';


--
-- Name: COLUMN biometric_connections.last_sync_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.last_sync_at IS 'Timestamp of last punch transaction sync';


--
-- Name: COLUMN biometric_connections.last_employee_sync_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.last_employee_sync_at IS 'Timestamp of last employee sync';


--
-- Name: biometric_connections biometric_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT biometric_connections_pkey PRIMARY KEY (id);


--
-- Name: biometric_connections unique_branch_device; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT unique_branch_device UNIQUE (branch_id, device_id);


--
-- Name: idx_biometric_connections_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_biometric_connections_active ON public.biometric_connections USING btree (is_active);


--
-- Name: idx_biometric_connections_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_biometric_connections_branch ON public.biometric_connections USING btree (branch_id);


--
-- Name: idx_biometric_connections_device; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_biometric_connections_device ON public.biometric_connections USING btree (device_id);


--
-- Name: idx_biometric_connections_terminal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_biometric_connections_terminal ON public.biometric_connections USING btree (terminal_sn);


--
-- Name: biometric_connections biometric_connections_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT biometric_connections_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: biometric_connections Allow anon insert biometric_connections; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert biometric_connections" ON public.biometric_connections FOR INSERT TO anon WITH CHECK (true);


--
-- Name: biometric_connections Enable delete for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for authenticated users" ON public.biometric_connections FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: biometric_connections Enable insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users" ON public.biometric_connections FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: biometric_connections Enable read for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read for authenticated users" ON public.biometric_connections FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: biometric_connections Enable update for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for authenticated users" ON public.biometric_connections FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: biometric_connections allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.biometric_connections USING (true) WITH CHECK (true);


--
-- Name: biometric_connections allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.biometric_connections FOR DELETE USING (true);


--
-- Name: biometric_connections allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.biometric_connections FOR INSERT WITH CHECK (true);


--
-- Name: biometric_connections allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.biometric_connections FOR SELECT USING (true);


--
-- Name: biometric_connections allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.biometric_connections FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: biometric_connections anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.biometric_connections USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: biometric_connections authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.biometric_connections USING ((auth.uid() IS NOT NULL));


--
-- Name: biometric_connections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.biometric_connections ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE biometric_connections; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.biometric_connections TO anon;
GRANT SELECT ON TABLE public.biometric_connections TO authenticated;
GRANT ALL ON TABLE public.biometric_connections TO service_role;
GRANT SELECT ON TABLE public.biometric_connections TO replication_user;


--
-- PostgreSQL database dump complete
--


