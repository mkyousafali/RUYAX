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
-- Name: special_shift_date_wise; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.special_shift_date_wise (
    id text NOT NULL,
    employee_id text NOT NULL,
    shift_date date NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0,
    is_shift_overlapping_next_day boolean DEFAULT false,
    working_hours numeric(5,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: special_shift_date_wise special_shift_date_wise_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT special_shift_date_wise_pkey PRIMARY KEY (id);


--
-- Name: special_shift_date_wise unique_employee_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT unique_employee_date UNIQUE (employee_id, shift_date);


--
-- Name: idx_special_shift_date_wise_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_shift_date_wise_date ON public.special_shift_date_wise USING btree (shift_date);


--
-- Name: idx_special_shift_date_wise_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_special_shift_date_wise_employee_id ON public.special_shift_date_wise USING btree (employee_id);


--
-- Name: special_shift_date_wise special_shift_date_wise_timestamp_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER special_shift_date_wise_timestamp_trigger BEFORE UPDATE ON public.special_shift_date_wise FOR EACH ROW EXECUTE FUNCTION public.update_special_shift_date_wise_timestamp();


--
-- Name: special_shift_date_wise special_shift_date_wise_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT special_shift_date_wise_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: special_shift_date_wise Allow all operations on special_shift_date_wise; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations on special_shift_date_wise" ON public.special_shift_date_wise USING (true) WITH CHECK (true);


--
-- Name: special_shift_date_wise; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.special_shift_date_wise ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE special_shift_date_wise; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.special_shift_date_wise TO anon;
GRANT ALL ON TABLE public.special_shift_date_wise TO authenticated;
GRANT ALL ON TABLE public.special_shift_date_wise TO service_role;
GRANT SELECT ON TABLE public.special_shift_date_wise TO replication_user;


--
-- PostgreSQL database dump complete
--

