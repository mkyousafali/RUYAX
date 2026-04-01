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
-- Name: warning_violation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.warning_violation (
    id character varying(10) NOT NULL,
    sub_category_id character varying(10) NOT NULL,
    main_category_id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: warning_violation warning_violation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_pkey PRIMARY KEY (id);


--
-- Name: idx_warning_violation_main_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_warning_violation_main_id ON public.warning_violation USING btree (main_category_id);


--
-- Name: idx_warning_violation_name_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_warning_violation_name_en ON public.warning_violation USING btree (name_en);


--
-- Name: idx_warning_violation_sub_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_warning_violation_sub_id ON public.warning_violation USING btree (sub_category_id);


--
-- Name: warning_violation warning_violation_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER warning_violation_timestamp_update BEFORE UPDATE ON public.warning_violation FOR EACH ROW EXECUTE FUNCTION public.update_warning_violation_timestamp();


--
-- Name: warning_violation warning_violation_main_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_main_category_id_fkey FOREIGN KEY (main_category_id) REFERENCES public.warning_main_category(id) ON DELETE CASCADE;


--
-- Name: warning_violation warning_violation_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.warning_sub_category(id) ON DELETE CASCADE;


--
-- Name: warning_violation Allow all access to warning_violation; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to warning_violation" ON public.warning_violation USING (true) WITH CHECK (true);


--
-- Name: warning_violation; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.warning_violation ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE warning_violation; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.warning_violation TO anon;
GRANT ALL ON TABLE public.warning_violation TO authenticated;
GRANT ALL ON TABLE public.warning_violation TO service_role;
GRANT SELECT ON TABLE public.warning_violation TO replication_user;


--
-- PostgreSQL database dump complete
--

