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
-- Name: receiving_user_defaults; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receiving_user_defaults (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: receiving_user_defaults receiving_user_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_pkey PRIMARY KEY (id);


--
-- Name: receiving_user_defaults receiving_user_defaults_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_user_id_key UNIQUE (user_id);


--
-- Name: idx_receiving_user_defaults_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_user_defaults_branch_id ON public.receiving_user_defaults USING btree (default_branch_id);


--
-- Name: idx_receiving_user_defaults_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receiving_user_defaults_user_id ON public.receiving_user_defaults USING btree (user_id);


--
-- Name: receiving_user_defaults receiving_user_defaults_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER receiving_user_defaults_timestamp_update BEFORE UPDATE ON public.receiving_user_defaults FOR EACH ROW EXECUTE FUNCTION public.update_receiving_user_defaults_timestamp();


--
-- Name: receiving_user_defaults receiving_user_defaults_default_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: receiving_user_defaults receiving_user_defaults_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: receiving_user_defaults Allow all access to receiving_user_defaults; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to receiving_user_defaults" ON public.receiving_user_defaults USING (true) WITH CHECK (true);


--
-- Name: receiving_user_defaults; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.receiving_user_defaults ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE receiving_user_defaults; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.receiving_user_defaults TO anon;
GRANT ALL ON TABLE public.receiving_user_defaults TO authenticated;
GRANT ALL ON TABLE public.receiving_user_defaults TO service_role;
GRANT SELECT ON TABLE public.receiving_user_defaults TO replication_user;


--
-- PostgreSQL database dump complete
--

