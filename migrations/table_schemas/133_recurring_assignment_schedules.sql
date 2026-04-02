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
-- Name: recurring_assignment_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recurring_assignment_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    repeat_type text NOT NULL,
    repeat_interval integer DEFAULT 1 NOT NULL,
    repeat_on_days integer[],
    repeat_on_date integer,
    repeat_on_month integer,
    execute_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    timezone text DEFAULT 'UTC'::text,
    start_date date NOT NULL,
    end_date date,
    max_occurrences integer,
    is_active boolean DEFAULT true,
    last_executed_at timestamp with time zone,
    next_execution_at timestamp with time zone NOT NULL,
    executions_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by text NOT NULL,
    CONSTRAINT chk_max_occurrences_positive CHECK (((max_occurrences IS NULL) OR (max_occurrences > 0))),
    CONSTRAINT chk_next_execution_after_start CHECK (((next_execution_at)::date >= start_date)),
    CONSTRAINT chk_repeat_interval_positive CHECK ((repeat_interval > 0)),
    CONSTRAINT chk_schedule_bounds CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT recurring_assignment_schedules_repeat_type_check CHECK ((repeat_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text, 'yearly'::text, 'custom'::text])))
);


--
-- Name: TABLE recurring_assignment_schedules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.recurring_assignment_schedules IS 'Configuration for recurring task assignments with flexible scheduling';


--
-- Name: recurring_assignment_schedules recurring_assignment_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_assignment_schedules
    ADD CONSTRAINT recurring_assignment_schedules_pkey PRIMARY KEY (id);


--
-- Name: idx_recurring_schedules_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recurring_schedules_active ON public.recurring_assignment_schedules USING btree (is_active, repeat_type);


--
-- Name: idx_recurring_schedules_assignment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recurring_schedules_assignment_id ON public.recurring_assignment_schedules USING btree (assignment_id);


--
-- Name: idx_recurring_schedules_next_execution; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recurring_schedules_next_execution ON public.recurring_assignment_schedules USING btree (next_execution_at, is_active) WHERE (is_active = true);


--
-- Name: recurring_assignment_schedules fk_recurring_schedules_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_assignment_schedules
    ADD CONSTRAINT fk_recurring_schedules_assignment FOREIGN KEY (assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;


--
-- Name: recurring_assignment_schedules Allow anon insert recurring_assignment_schedules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert recurring_assignment_schedules" ON public.recurring_assignment_schedules FOR INSERT TO anon WITH CHECK (true);


--
-- Name: recurring_assignment_schedules allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.recurring_assignment_schedules USING (true) WITH CHECK (true);


--
-- Name: recurring_assignment_schedules allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.recurring_assignment_schedules FOR DELETE USING (true);


--
-- Name: recurring_assignment_schedules allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.recurring_assignment_schedules FOR INSERT WITH CHECK (true);


--
-- Name: recurring_assignment_schedules allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.recurring_assignment_schedules FOR SELECT USING (true);


--
-- Name: recurring_assignment_schedules allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.recurring_assignment_schedules FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: recurring_assignment_schedules anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.recurring_assignment_schedules USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: recurring_assignment_schedules authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.recurring_assignment_schedules USING ((auth.uid() IS NOT NULL));


--
-- Name: recurring_assignment_schedules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.recurring_assignment_schedules ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE recurring_assignment_schedules; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.recurring_assignment_schedules TO anon;
GRANT SELECT ON TABLE public.recurring_assignment_schedules TO authenticated;
GRANT ALL ON TABLE public.recurring_assignment_schedules TO service_role;
GRANT SELECT ON TABLE public.recurring_assignment_schedules TO replication_user;


--
-- PostgreSQL database dump complete
--

