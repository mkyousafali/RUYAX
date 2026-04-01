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
-- Name: hr_checklist_operations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_checklist_operations (
    id character varying(20) DEFAULT ('CLO'::text || nextval('public.hr_checklist_operations_id_seq'::regclass)) NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50),
    box_operation_id uuid,
    checklist_id character varying(20) NOT NULL,
    answers jsonb DEFAULT '[]'::jsonb NOT NULL,
    total_points integer DEFAULT 0 NOT NULL,
    branch_id bigint,
    operation_date date DEFAULT CURRENT_DATE NOT NULL,
    operation_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    box_number integer,
    max_points integer DEFAULT 0 NOT NULL,
    submission_type_en text,
    submission_type_ar text
);


--
-- Name: COLUMN hr_checklist_operations.answers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.answers IS 'JSONB array: [{ question_id: "Q1", answer_key: "a1", answer_text: "Yes", points: 5, remarks: "...", other_value: "..." }, ...]';


--
-- Name: COLUMN hr_checklist_operations.max_points; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.max_points IS 'Total possible points from all questions in the checklist';


--
-- Name: COLUMN hr_checklist_operations.submission_type_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_en IS 'Submission type in English: POS, Daily, Weekly';


--
-- Name: COLUMN hr_checklist_operations.submission_type_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_ar IS 'Submission type in Arabic: POS, ┘è┘ê┘à┘è, ╪ú╪│╪¿┘ê╪╣┘è';


--
-- Name: hr_checklist_operations hr_checklist_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_pkey PRIMARY KEY (id);


--
-- Name: idx_checklist_operations_submission_type_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_checklist_operations_submission_type_en ON public.hr_checklist_operations USING btree (submission_type_en);


--
-- Name: idx_hr_checklist_operations_box; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_box ON public.hr_checklist_operations USING btree (box_operation_id);


--
-- Name: idx_hr_checklist_operations_box_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_box_number ON public.hr_checklist_operations USING btree (box_number);


--
-- Name: idx_hr_checklist_operations_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_branch ON public.hr_checklist_operations USING btree (branch_id);


--
-- Name: idx_hr_checklist_operations_checklist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_checklist ON public.hr_checklist_operations USING btree (checklist_id);


--
-- Name: idx_hr_checklist_operations_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_created ON public.hr_checklist_operations USING btree (created_at DESC);


--
-- Name: idx_hr_checklist_operations_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_date ON public.hr_checklist_operations USING btree (operation_date DESC);


--
-- Name: idx_hr_checklist_operations_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_employee ON public.hr_checklist_operations USING btree (employee_id);


--
-- Name: idx_hr_checklist_operations_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_operations_user ON public.hr_checklist_operations USING btree (user_id);


--
-- Name: hr_checklist_operations hr_checklist_operations_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hr_checklist_operations_timestamp_update BEFORE UPDATE ON public.hr_checklist_operations FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklist_operations_timestamp();


--
-- Name: hr_checklist_operations hr_checklist_operations_box_operation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_box_operation_id_fkey FOREIGN KEY (box_operation_id) REFERENCES public.box_operations(id) ON DELETE SET NULL;


--
-- Name: hr_checklist_operations hr_checklist_operations_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: hr_checklist_operations hr_checklist_operations_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.hr_checklists(id) ON DELETE CASCADE;


--
-- Name: hr_checklist_operations hr_checklist_operations_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE SET NULL;


--
-- Name: hr_checklist_operations Allow all access to hr_checklist_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to hr_checklist_operations" ON public.hr_checklist_operations USING (true) WITH CHECK (true);


--
-- Name: hr_checklist_operations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_checklist_operations ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_checklist_operations; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hr_checklist_operations TO anon;
GRANT ALL ON TABLE public.hr_checklist_operations TO authenticated;
GRANT ALL ON TABLE public.hr_checklist_operations TO service_role;
GRANT SELECT ON TABLE public.hr_checklist_operations TO replication_user;


--
-- PostgreSQL database dump complete
--

