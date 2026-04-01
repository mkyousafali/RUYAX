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
-- Name: requesters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.requesters (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_id character varying(50) NOT NULL,
    requester_name character varying(255) NOT NULL,
    contact_number character varying(20),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid
);


--
-- Name: TABLE requesters; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.requesters IS 'Table to store requester information for expense requisitions';


--
-- Name: COLUMN requesters.requester_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requesters.requester_id IS 'Unique identifier for the requester (employee ID or custom ID)';


--
-- Name: COLUMN requesters.requester_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requesters.requester_name IS 'Full name of the requester';


--
-- Name: COLUMN requesters.contact_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requesters.contact_number IS 'Contact number of the requester';


--
-- Name: requesters requesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requesters
    ADD CONSTRAINT requesters_pkey PRIMARY KEY (id);


--
-- Name: requesters requesters_requester_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requesters
    ADD CONSTRAINT requesters_requester_id_key UNIQUE (requester_id);


--
-- Name: idx_requesters_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requesters_name ON public.requesters USING btree (requester_name);


--
-- Name: idx_requesters_requester_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_requesters_requester_id ON public.requesters USING btree (requester_id);


--
-- Name: requesters update_requesters_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_requesters_updated_at BEFORE UPDATE ON public.requesters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: requesters Allow anon insert requesters; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert requesters" ON public.requesters FOR INSERT TO anon WITH CHECK (true);


--
-- Name: requesters Users can insert requesters; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert requesters" ON public.requesters FOR INSERT WITH CHECK (true);


--
-- Name: requesters Users can update requesters; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update requesters" ON public.requesters FOR UPDATE USING (true);


--
-- Name: requesters Users can view all requesters; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view all requesters" ON public.requesters FOR SELECT USING (true);


--
-- Name: requesters allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.requesters USING (true) WITH CHECK (true);


--
-- Name: requesters allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.requesters FOR DELETE USING (true);


--
-- Name: requesters allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.requesters FOR INSERT WITH CHECK (true);


--
-- Name: requesters allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.requesters FOR SELECT USING (true);


--
-- Name: requesters allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.requesters FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: requesters anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.requesters USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: requesters authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.requesters USING ((auth.uid() IS NOT NULL));


--
-- Name: requesters; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.requesters ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE requesters; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.requesters TO anon;
GRANT SELECT ON TABLE public.requesters TO authenticated;
GRANT ALL ON TABLE public.requesters TO service_role;
GRANT SELECT ON TABLE public.requesters TO replication_user;


--
-- PostgreSQL database dump complete
--

