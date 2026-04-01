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
-- Name: hr_checklist_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_checklist_questions (
    id character varying(20) DEFAULT ('Q'::text || nextval('public.hr_checklist_questions_id_seq'::regclass)) NOT NULL,
    question_en text,
    question_ar text,
    answer_1_en text,
    answer_1_ar text,
    answer_1_points integer DEFAULT 0,
    answer_2_en text,
    answer_2_ar text,
    answer_2_points integer DEFAULT 0,
    answer_3_en text,
    answer_3_ar text,
    answer_3_points integer DEFAULT 0,
    answer_4_en text,
    answer_4_ar text,
    answer_4_points integer DEFAULT 0,
    answer_5_en text,
    answer_5_ar text,
    answer_5_points integer DEFAULT 0,
    answer_6_en text,
    answer_6_ar text,
    answer_6_points integer DEFAULT 0,
    has_remarks boolean DEFAULT false,
    has_other boolean DEFAULT false,
    other_points integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: hr_checklist_questions hr_checklist_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_questions
    ADD CONSTRAINT hr_checklist_questions_pkey PRIMARY KEY (id);


--
-- Name: idx_hr_checklist_questions_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_checklist_questions_created ON public.hr_checklist_questions USING btree (created_at DESC);


--
-- Name: hr_checklist_questions hr_checklist_questions_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hr_checklist_questions_timestamp_update BEFORE UPDATE ON public.hr_checklist_questions FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklist_questions_timestamp();


--
-- Name: hr_checklist_questions Allow all access to hr_checklist_questions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to hr_checklist_questions" ON public.hr_checklist_questions USING (true) WITH CHECK (true);


--
-- Name: hr_checklist_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_checklist_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_checklist_questions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hr_checklist_questions TO anon;
GRANT ALL ON TABLE public.hr_checklist_questions TO authenticated;
GRANT ALL ON TABLE public.hr_checklist_questions TO service_role;
GRANT SELECT ON TABLE public.hr_checklist_questions TO replication_user;


--
-- PostgreSQL database dump complete
--

