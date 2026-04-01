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
-- Name: user_favorite_buttons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_favorite_buttons (
    id text NOT NULL,
    employee_id text,
    user_id uuid NOT NULL,
    favorite_config jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_favorite_buttons unique_user_favorite; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_favorite_buttons
    ADD CONSTRAINT unique_user_favorite UNIQUE (user_id);


--
-- Name: user_favorite_buttons user_favorite_buttons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_favorite_buttons
    ADD CONSTRAINT user_favorite_buttons_pkey PRIMARY KEY (id);


--
-- Name: idx_user_favorite_buttons_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_favorite_buttons_employee_id ON public.user_favorite_buttons USING btree (employee_id);


--
-- Name: idx_user_favorite_buttons_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_favorite_buttons_user_id ON public.user_favorite_buttons USING btree (user_id);


--
-- Name: user_favorite_buttons Allow all access to user_favorite_buttons; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to user_favorite_buttons" ON public.user_favorite_buttons USING (true) WITH CHECK (true);


--
-- Name: user_favorite_buttons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_favorite_buttons ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE user_favorite_buttons; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.user_favorite_buttons TO anon;
GRANT ALL ON TABLE public.user_favorite_buttons TO authenticated;
GRANT ALL ON TABLE public.user_favorite_buttons TO service_role;
GRANT SELECT ON TABLE public.user_favorite_buttons TO replication_user;


--
-- PostgreSQL database dump complete
--

