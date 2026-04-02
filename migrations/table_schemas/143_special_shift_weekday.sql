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
-- Name: special_shift_weekday; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.special_shift_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT special_shift_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);


--
-- Name: special_shift_weekday special_shift_weekday_employee_id_weekday_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_employee_id_weekday_key UNIQUE (employee_id, weekday);


--
-- Name: special_shift_weekday special_shift_weekday_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_pkey PRIMARY KEY (id);


--
-- Name: idx_special_shift_weekday_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_shift_weekday_created_at ON public.special_shift_weekday USING btree (created_at);


--
-- Name: idx_special_shift_weekday_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_shift_weekday_employee_id ON public.special_shift_weekday USING btree (employee_id);


--
-- Name: idx_special_shift_weekday_weekday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_shift_weekday_weekday ON public.special_shift_weekday USING btree (weekday);


--
-- Name: special_shift_weekday special_shift_weekday_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER special_shift_weekday_timestamp_update BEFORE UPDATE ON public.special_shift_weekday FOR EACH ROW EXECUTE FUNCTION public.update_special_shift_weekday_timestamp();


--
-- Name: special_shift_weekday special_shift_weekday_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: special_shift_weekday; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.special_shift_weekday ENABLE ROW LEVEL SECURITY;

--
-- Name: special_shift_weekday special_shift_weekday_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY special_shift_weekday_policy ON public.special_shift_weekday USING (true) WITH CHECK (true);


--
-- Name: TABLE special_shift_weekday; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.special_shift_weekday TO anon;
GRANT ALL ON TABLE public.special_shift_weekday TO authenticated;
GRANT ALL ON TABLE public.special_shift_weekday TO service_role;
GRANT SELECT ON TABLE public.special_shift_weekday TO replication_user;


--
-- PostgreSQL database dump complete
--

