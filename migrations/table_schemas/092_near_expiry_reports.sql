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
-- Name: near_expiry_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.near_expiry_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    reporter_user_id uuid NOT NULL,
    branch_id integer,
    target_user_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    title text,
    CONSTRAINT near_expiry_reports_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'resolved'::text, 'dismissed'::text])))
);


--
-- Name: near_expiry_reports near_expiry_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_pkey PRIMARY KEY (id);


--
-- Name: idx_near_expiry_reports_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_near_expiry_reports_branch ON public.near_expiry_reports USING btree (branch_id);


--
-- Name: idx_near_expiry_reports_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_near_expiry_reports_created ON public.near_expiry_reports USING btree (created_at DESC);


--
-- Name: idx_near_expiry_reports_reporter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_near_expiry_reports_reporter ON public.near_expiry_reports USING btree (reporter_user_id);


--
-- Name: idx_near_expiry_reports_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_near_expiry_reports_status ON public.near_expiry_reports USING btree (status);


--
-- Name: idx_near_expiry_reports_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_near_expiry_reports_target ON public.near_expiry_reports USING btree (target_user_id);


--
-- Name: near_expiry_reports trigger_update_near_expiry_reports_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_near_expiry_reports_updated_at BEFORE UPDATE ON public.near_expiry_reports FOR EACH ROW EXECUTE FUNCTION public.update_near_expiry_reports_updated_at();


--
-- Name: near_expiry_reports near_expiry_reports_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: near_expiry_reports near_expiry_reports_reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id);


--
-- Name: near_expiry_reports near_expiry_reports_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id);


--
-- Name: near_expiry_reports Allow all access to near_expiry_reports; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to near_expiry_reports" ON public.near_expiry_reports USING (true) WITH CHECK (true);


--
-- Name: near_expiry_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.near_expiry_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE near_expiry_reports; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.near_expiry_reports TO anon;
GRANT ALL ON TABLE public.near_expiry_reports TO authenticated;
GRANT ALL ON TABLE public.near_expiry_reports TO service_role;
GRANT SELECT ON TABLE public.near_expiry_reports TO replication_user;


--
-- PostgreSQL database dump complete
--

