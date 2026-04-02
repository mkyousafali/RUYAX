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
-- Name: user_mobile_theme_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_mobile_theme_assignments (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    theme_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    color_overrides jsonb
);


--
-- Name: COLUMN user_mobile_theme_assignments.color_overrides; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_mobile_theme_assignments.color_overrides IS 'User-specific color overrides. Merge with theme colors at runtime. Stores only properties that differ from base theme.';


--
-- Name: user_mobile_theme_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_mobile_theme_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_mobile_theme_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_mobile_theme_assignments_id_seq OWNED BY public.user_mobile_theme_assignments.id;


--
-- Name: user_mobile_theme_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_mobile_theme_assignments_id_seq'::regclass);


--
-- Name: user_mobile_theme_assignments user_mobile_theme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_pkey PRIMARY KEY (id);


--
-- Name: user_mobile_theme_assignments user_mobile_theme_assignments_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_user_id_key UNIQUE (user_id);


--
-- Name: idx_user_mobile_theme_assignments_theme_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_mobile_theme_assignments_theme_id ON public.user_mobile_theme_assignments USING btree (theme_id);


--
-- Name: idx_user_mobile_theme_assignments_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_mobile_theme_assignments_user_id ON public.user_mobile_theme_assignments USING btree (user_id);


--
-- Name: idx_user_theme_overrides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_theme_overrides ON public.user_mobile_theme_assignments USING btree (user_id) WHERE (color_overrides IS NOT NULL);


--
-- Name: user_mobile_theme_assignments user_mobile_theme_assignments_theme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_theme_id_fkey FOREIGN KEY (theme_id) REFERENCES public.mobile_themes(id) ON DELETE CASCADE;


--
-- Name: user_mobile_theme_assignments Allow all access to user_mobile_theme_assignments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to user_mobile_theme_assignments" ON public.user_mobile_theme_assignments USING (true) WITH CHECK (true);


--
-- Name: user_mobile_theme_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_mobile_theme_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE user_mobile_theme_assignments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.user_mobile_theme_assignments TO anon;
GRANT ALL ON TABLE public.user_mobile_theme_assignments TO authenticated;
GRANT ALL ON TABLE public.user_mobile_theme_assignments TO service_role;
GRANT SELECT ON TABLE public.user_mobile_theme_assignments TO replication_user;


--
-- Name: SEQUENCE user_mobile_theme_assignments_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO anon;


--
-- PostgreSQL database dump complete
--

