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
-- Name: regular_shift; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regular_shift (
    id text NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    working_hours numeric(5,2) DEFAULT 0
);


--
-- Name: regular_shift regular_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regular_shift
    ADD CONSTRAINT regular_shift_pkey PRIMARY KEY (id);


--
-- Name: idx_regular_shift_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_regular_shift_created_at ON public.regular_shift USING btree (created_at);


--
-- Name: idx_regular_shift_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_regular_shift_updated_at ON public.regular_shift USING btree (updated_at);


--
-- Name: regular_shift calculate_working_hours_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER calculate_working_hours_trigger BEFORE INSERT OR UPDATE ON public.regular_shift FOR EACH ROW EXECUTE FUNCTION public.calculate_working_hours();


--
-- Name: regular_shift regular_shift_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER regular_shift_timestamp_update BEFORE UPDATE ON public.regular_shift FOR EACH ROW EXECUTE FUNCTION public.update_regular_shift_timestamp();


--
-- Name: regular_shift regular_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regular_shift
    ADD CONSTRAINT regular_shift_id_fkey FOREIGN KEY (id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: regular_shift Allow all access to regular_shift; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to regular_shift" ON public.regular_shift USING (true) WITH CHECK (true);


--
-- Name: regular_shift; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.regular_shift ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE regular_shift; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.regular_shift TO anon;
GRANT ALL ON TABLE public.regular_shift TO authenticated;
GRANT ALL ON TABLE public.regular_shift TO service_role;
GRANT SELECT ON TABLE public.regular_shift TO replication_user;


--
-- PostgreSQL database dump complete
--

