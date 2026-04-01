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
-- Name: expense_sub_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expense_sub_categories (
    id bigint NOT NULL,
    parent_category_id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);


--
-- Name: TABLE expense_sub_categories; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.expense_sub_categories IS 'Sub expense categories linked to parent categories with bilingual support';


--
-- Name: expense_sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expense_sub_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expense_sub_categories_id_seq OWNED BY public.expense_sub_categories.id;


--
-- Name: expense_sub_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_sub_categories_id_seq'::regclass);


--
-- Name: expense_sub_categories expense_sub_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sub_categories
    ADD CONSTRAINT expense_sub_categories_pkey PRIMARY KEY (id);


--
-- Name: idx_expense_sub_categories_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_sub_categories_is_active ON public.expense_sub_categories USING btree (is_active);


--
-- Name: idx_expense_sub_categories_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expense_sub_categories_parent ON public.expense_sub_categories USING btree (parent_category_id);


--
-- Name: expense_sub_categories expense_sub_categories_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sub_categories
    ADD CONSTRAINT expense_sub_categories_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES public.expense_parent_categories(id) ON DELETE CASCADE;


--
-- Name: expense_sub_categories Allow admin users to delete sub categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admin users to delete sub categories" ON public.expense_sub_categories FOR DELETE TO authenticated USING (true);


--
-- Name: expense_sub_categories Allow admin users to insert sub categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admin users to insert sub categories" ON public.expense_sub_categories FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: expense_sub_categories Allow admin users to update sub categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admin users to update sub categories" ON public.expense_sub_categories FOR UPDATE TO authenticated USING (true);


--
-- Name: expense_sub_categories Allow anon insert expense_sub_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert expense_sub_categories" ON public.expense_sub_categories FOR INSERT TO anon WITH CHECK (true);


--
-- Name: expense_sub_categories Allow authenticated users to read sub categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read sub categories" ON public.expense_sub_categories FOR SELECT TO authenticated USING (true);


--
-- Name: expense_sub_categories allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.expense_sub_categories USING (true) WITH CHECK (true);


--
-- Name: expense_sub_categories allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.expense_sub_categories FOR DELETE USING (true);


--
-- Name: expense_sub_categories allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.expense_sub_categories FOR INSERT WITH CHECK (true);


--
-- Name: expense_sub_categories allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.expense_sub_categories FOR SELECT USING (true);


--
-- Name: expense_sub_categories allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.expense_sub_categories FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: expense_sub_categories anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.expense_sub_categories USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: expense_sub_categories authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.expense_sub_categories USING ((auth.uid() IS NOT NULL));


--
-- Name: expense_sub_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expense_sub_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE expense_sub_categories; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.expense_sub_categories TO anon;
GRANT SELECT ON TABLE public.expense_sub_categories TO authenticated;
GRANT ALL ON TABLE public.expense_sub_categories TO service_role;
GRANT SELECT ON TABLE public.expense_sub_categories TO replication_user;


--
-- Name: SEQUENCE expense_sub_categories_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO anon;
GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.expense_sub_categories_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

