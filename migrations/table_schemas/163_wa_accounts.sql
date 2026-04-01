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
-- Name: wa_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    display_name text,
    waba_id text,
    phone_number_id text,
    access_token text,
    quality_rating character varying(10) DEFAULT 'GREEN'::character varying,
    status character varying(20) DEFAULT 'connected'::character varying,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    branch_id uuid,
    payment_pending numeric(12,2) DEFAULT 0,
    payment_currency text DEFAULT 'USD'::text,
    last_payment_date timestamp without time zone,
    meta_business_account_id text,
    meta_access_token text
);


--
-- Name: wa_accounts wa_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_accounts
    ADD CONSTRAINT wa_accounts_pkey PRIMARY KEY (id);


--
-- Name: wa_accounts Allow all access to wa_accounts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to wa_accounts" ON public.wa_accounts USING (true) WITH CHECK (true);


--
-- Name: wa_accounts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_accounts ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_accounts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_accounts TO anon;
GRANT ALL ON TABLE public.wa_accounts TO authenticated;
GRANT ALL ON TABLE public.wa_accounts TO service_role;
GRANT SELECT ON TABLE public.wa_accounts TO replication_user;


--
-- PostgreSQL database dump complete
--

