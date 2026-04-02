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
-- Name: approver_visibility_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approver_visibility_config (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    visibility_type character varying(50) DEFAULT 'global'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT approver_visibility_type_check CHECK (((visibility_type)::text = ANY ((ARRAY['global'::character varying, 'branch_specific'::character varying, 'multiple_branches'::character varying])::text[])))
);


--
-- Name: approver_visibility_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approver_visibility_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approver_visibility_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approver_visibility_config_id_seq OWNED BY public.approver_visibility_config.id;


--
-- Name: approver_visibility_config id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config ALTER COLUMN id SET DEFAULT nextval('public.approver_visibility_config_id_seq'::regclass);


--
-- Name: approver_visibility_config approver_visibility_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_pkey PRIMARY KEY (id);


--
-- Name: approver_visibility_config approver_visibility_config_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_key UNIQUE (user_id);


--
-- Name: idx_approver_visibility_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approver_visibility_active ON public.approver_visibility_config USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_approver_visibility_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approver_visibility_type ON public.approver_visibility_config USING btree (visibility_type);


--
-- Name: idx_approver_visibility_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_approver_visibility_user_id ON public.approver_visibility_config USING btree (user_id);


--
-- Name: approver_visibility_config approver_visibility_config_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER approver_visibility_config_timestamp_update BEFORE UPDATE ON public.approver_visibility_config FOR EACH ROW EXECUTE FUNCTION public.update_approver_visibility_config_timestamp();


--
-- Name: approver_visibility_config approver_visibility_config_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approver_visibility_config approver_visibility_config_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approver_visibility_config approver_visibility_config_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approver_visibility_config Allow all access to approver_visibility_config; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to approver_visibility_config" ON public.approver_visibility_config USING (true) WITH CHECK (true);


--
-- Name: approver_visibility_config; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.approver_visibility_config ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE approver_visibility_config; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.approver_visibility_config TO anon;
GRANT ALL ON TABLE public.approver_visibility_config TO authenticated;
GRANT ALL ON TABLE public.approver_visibility_config TO service_role;
GRANT SELECT ON TABLE public.approver_visibility_config TO replication_user;


--
-- Name: SEQUENCE approver_visibility_config_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO anon;
GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO authenticated;


--
-- PostgreSQL database dump complete
--

