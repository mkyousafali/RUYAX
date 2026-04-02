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
-- Name: day_off_weekday; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.day_off_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT day_off_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);


--
-- Name: day_off_weekday day_off_weekday_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT day_off_weekday_pkey PRIMARY KEY (id);


--
-- Name: day_off_weekday unique_employee_weekday_dayoff; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT unique_employee_weekday_dayoff UNIQUE (employee_id, weekday);


--
-- Name: idx_day_off_weekday_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_day_off_weekday_employee_id ON public.day_off_weekday USING btree (employee_id);


--
-- Name: idx_day_off_weekday_weekday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_day_off_weekday_weekday ON public.day_off_weekday USING btree (weekday);


--
-- Name: day_off_weekday day_off_weekday_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER day_off_weekday_updated_at_trigger BEFORE UPDATE ON public.day_off_weekday FOR EACH ROW EXECUTE FUNCTION public.update_day_off_weekday_updated_at();


--
-- Name: day_off_weekday day_off_weekday_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT day_off_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: day_off_weekday Allow all operations on day_off_weekday; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations on day_off_weekday" ON public.day_off_weekday USING (true) WITH CHECK (true);


--
-- Name: day_off_weekday; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.day_off_weekday ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE day_off_weekday; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.day_off_weekday TO anon;
GRANT ALL ON TABLE public.day_off_weekday TO authenticated;
GRANT ALL ON TABLE public.day_off_weekday TO service_role;
GRANT SELECT ON TABLE public.day_off_weekday TO replication_user;


--
-- PostgreSQL database dump complete
--

