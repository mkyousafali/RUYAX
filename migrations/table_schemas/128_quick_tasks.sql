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
-- Name: quick_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price_tag character varying(50),
    issue_type character varying(100) NOT NULL,
    priority character varying(50) NOT NULL,
    assigned_by uuid NOT NULL,
    assigned_to_branch_id bigint,
    created_at timestamp with time zone DEFAULT now(),
    deadline_datetime timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    completed_at timestamp with time zone,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_from character varying(50) DEFAULT 'quick_task'::character varying,
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    incident_id text,
    product_request_id uuid,
    product_request_type character varying(5),
    order_id uuid,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);


--
-- Name: COLUMN quick_tasks.require_task_finished; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.require_task_finished IS 'Default requirement for task completion (always required)';


--
-- Name: COLUMN quick_tasks.require_photo_upload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.require_photo_upload IS 'Default requirement for photo upload on task completion';


--
-- Name: COLUMN quick_tasks.require_erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.require_erp_reference IS 'Default requirement for ERP reference on task completion';


--
-- Name: COLUMN quick_tasks.incident_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.incident_id IS 'Reference to the incident that triggered this quick task';


--
-- Name: COLUMN quick_tasks.product_request_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.product_request_id IS 'Reference to the product request that triggered this quick task';


--
-- Name: COLUMN quick_tasks.product_request_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.product_request_type IS 'Type of product request: PO, ST, or BT';


--
-- Name: quick_tasks quick_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_pkey PRIMARY KEY (id);


--
-- Name: idx_quick_tasks_assigned_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_assigned_by ON public.quick_tasks USING btree (assigned_by);


--
-- Name: idx_quick_tasks_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_branch ON public.quick_tasks USING btree (assigned_to_branch_id);


--
-- Name: idx_quick_tasks_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_created_at ON public.quick_tasks USING btree (created_at);


--
-- Name: idx_quick_tasks_deadline; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_deadline ON public.quick_tasks USING btree (deadline_datetime);


--
-- Name: idx_quick_tasks_incident_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_incident_id ON public.quick_tasks USING btree (incident_id);


--
-- Name: idx_quick_tasks_issue_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_issue_type ON public.quick_tasks USING btree (issue_type);


--
-- Name: idx_quick_tasks_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_order_id ON public.quick_tasks USING btree (order_id);


--
-- Name: idx_quick_tasks_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_priority ON public.quick_tasks USING btree (priority);


--
-- Name: idx_quick_tasks_product_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_product_request_id ON public.quick_tasks USING btree (product_request_id);


--
-- Name: idx_quick_tasks_product_request_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_product_request_type ON public.quick_tasks USING btree (product_request_type);


--
-- Name: idx_quick_tasks_require_erp_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_require_erp_reference ON public.quick_tasks USING btree (require_erp_reference) WHERE (require_erp_reference = true);


--
-- Name: idx_quick_tasks_require_photo_upload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_require_photo_upload ON public.quick_tasks USING btree (require_photo_upload) WHERE (require_photo_upload = true);


--
-- Name: idx_quick_tasks_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quick_tasks_status ON public.quick_tasks USING btree (status);


--
-- Name: quick_tasks quick_tasks_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_tasks quick_tasks_assigned_to_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: quick_tasks quick_tasks_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id);


--
-- Name: quick_tasks quick_tasks_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL;


--
-- Name: quick_tasks Allow anon insert quick_tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert quick_tasks" ON public.quick_tasks FOR INSERT TO anon WITH CHECK (true);


--
-- Name: quick_tasks Allow service role full access to quick_tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow service role full access to quick_tasks" ON public.quick_tasks TO authenticated USING (true) WITH CHECK (true);


--
-- Name: quick_tasks allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.quick_tasks USING (true) WITH CHECK (true);


--
-- Name: quick_tasks allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.quick_tasks FOR DELETE USING (true);


--
-- Name: quick_tasks allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.quick_tasks FOR INSERT WITH CHECK (true);


--
-- Name: quick_tasks allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.quick_tasks FOR SELECT USING (true);


--
-- Name: quick_tasks allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.quick_tasks FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: quick_tasks anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.quick_tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_tasks authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.quick_tasks USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.quick_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE quick_tasks; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_tasks TO anon;
GRANT SELECT ON TABLE public.quick_tasks TO authenticated;
GRANT ALL ON TABLE public.quick_tasks TO service_role;
GRANT SELECT ON TABLE public.quick_tasks TO replication_user;


--
-- PostgreSQL database dump complete
--

