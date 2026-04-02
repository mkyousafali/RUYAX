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

--
-- Name: _analytics; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA _analytics;



--
-- Name: _supavisor; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA _supavisor;



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alert_queries; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.alert_queries (
    id bigint NOT NULL,
    name character varying(255),
    token uuid,
    query text,
    description text,
    language character varying(255),
    cron character varying(255),
    source_mapping jsonb,
    slack_hook_url character varying(255),
    webhook_notification_url character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: alert_queries_backends; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.alert_queries_backends (
    id bigint NOT NULL,
    alert_query_id bigint,
    backend_id bigint
);



--
-- Name: alert_queries_backends_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.alert_queries_backends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: alert_queries_backends_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.alert_queries_backends_id_seq OWNED BY _analytics.alert_queries_backends.id;


--
-- Name: alert_queries_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.alert_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: alert_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.alert_queries_id_seq OWNED BY _analytics.alert_queries.id;


--
-- Name: backends; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.backends (
    id bigint NOT NULL,
    name character varying(255),
    description text,
    user_id bigint,
    type character varying(255),
    config jsonb,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    token uuid NOT NULL,
    metadata jsonb,
    config_encrypted bytea,
    default_ingest boolean DEFAULT false
);



--
-- Name: backends_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.backends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: backends_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.backends_id_seq OWNED BY _analytics.backends.id;


--
-- Name: billing_accounts; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.billing_accounts (
    id bigint NOT NULL,
    latest_successful_stripe_session jsonb,
    stripe_customer character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    stripe_subscriptions jsonb,
    stripe_invoices jsonb,
    "lifetime_plan?" boolean DEFAULT false,
    lifetime_plan_invoice character varying(255),
    default_payment_method character varying(255),
    custom_invoice_fields jsonb[] DEFAULT ARRAY[]::jsonb[],
    lifetime_plan boolean DEFAULT false NOT NULL
);



--
-- Name: billing_accounts_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.billing_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: billing_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.billing_accounts_id_seq OWNED BY _analytics.billing_accounts.id;


--
-- Name: billing_counts; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.billing_counts (
    id bigint NOT NULL,
    node character varying(255),
    count integer,
    user_id bigint,
    source_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: billing_counts_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.billing_counts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: billing_counts_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.billing_counts_id_seq OWNED BY _analytics.billing_counts.id;


--
-- Name: endpoint_queries; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.endpoint_queries (
    id bigint NOT NULL,
    name character varying(255),
    token uuid,
    query text,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    source_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    sandboxable boolean DEFAULT false,
    cache_duration_seconds integer DEFAULT 3600,
    proactive_requerying_seconds integer DEFAULT 1800,
    max_limit integer DEFAULT 1000,
    enable_auth boolean DEFAULT false,
    language character varying(255) NOT NULL,
    description character varying(255),
    sandbox_query_id bigint,
    labels text,
    backend_id bigint,
    redact_pii boolean DEFAULT false NOT NULL
);



--
-- Name: endpoint_queries_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.endpoint_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: endpoint_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.endpoint_queries_id_seq OWNED BY _analytics.endpoint_queries.id;


--
-- Name: log_events_3128584f_7988_41bc_85f0_fa872b00d1d3; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_3128584f_7988_41bc_85f0_fa872b00d1d3 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_ed300f97_837d_45ee_9949_ca82175ec020; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_ed300f97_837d_45ee_9949_ca82175ec020 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7 (
    id text NOT NULL,
    body jsonb,
    event_message text,
    "timestamp" timestamp without time zone
);



--
-- Name: oauth_access_grants; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.oauth_access_grants (
    id bigint NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id bigint,
    token character varying(255) NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    revoked_at timestamp(0) without time zone,
    scopes character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);



--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.oauth_access_grants_id_seq OWNED BY _analytics.oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.oauth_access_tokens (
    id bigint NOT NULL,
    application_id bigint,
    resource_owner_id integer,
    token character varying(255) NOT NULL,
    refresh_token character varying(255),
    expires_in integer,
    revoked_at timestamp(0) without time zone,
    scopes character varying(255),
    previous_refresh_token character varying(255) DEFAULT ''::character varying NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    description text
);



--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.oauth_access_tokens_id_seq OWNED BY _analytics.oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.oauth_applications (
    id bigint NOT NULL,
    owner_id integer NOT NULL,
    name character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    secret character varying(255) DEFAULT ''::character varying NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    scopes character varying(255) DEFAULT ''::character varying NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.oauth_applications_id_seq OWNED BY _analytics.oauth_applications.id;


--
-- Name: partner_users; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.partner_users (
    id bigint NOT NULL,
    partner_id bigint,
    user_id bigint,
    upgraded boolean DEFAULT false NOT NULL
);



--
-- Name: partner_users_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.partner_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: partner_users_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.partner_users_id_seq OWNED BY _analytics.partner_users.id;


--
-- Name: partners; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.partners (
    id bigint NOT NULL,
    name bytea,
    token bytea
);



--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.partners_id_seq OWNED BY _analytics.partners.id;


--
-- Name: payment_methods; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.payment_methods (
    id bigint NOT NULL,
    stripe_id character varying(255),
    price_id character varying(255),
    last_four character varying(255),
    brand character varying(255),
    exp_year integer,
    exp_month integer,
    customer_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.payment_methods_id_seq OWNED BY _analytics.payment_methods.id;


--
-- Name: plans; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.plans (
    id bigint NOT NULL,
    name character varying(255),
    stripe_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    period character varying(255),
    price integer,
    limit_sources integer,
    limit_rate_limit integer,
    limit_alert_freq integer,
    limit_source_rate_limit integer,
    limit_saved_search_limit integer,
    limit_team_users_limit integer,
    limit_source_fields_limit integer,
    limit_source_ttl bigint DEFAULT 259200000,
    type character varying(255) DEFAULT 'standard'::character varying
);



--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.plans_id_seq OWNED BY _analytics.plans.id;


--
-- Name: rules; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.rules (
    id bigint NOT NULL,
    regex character varying(255),
    sink uuid,
    source_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    regex_struct bytea,
    lql_string text DEFAULT ''::text NOT NULL,
    lql_filters bytea DEFAULT '\x836a'::bytea NOT NULL,
    backend_id bigint,
    token uuid DEFAULT gen_random_uuid()
);

ALTER TABLE ONLY _analytics.rules REPLICA IDENTITY FULL;



--
-- Name: rules_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: rules_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.rules_id_seq OWNED BY _analytics.rules.id;


--
-- Name: saved_search_counters; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.saved_search_counters (
    id bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    saved_search_id bigint NOT NULL,
    granularity text DEFAULT 'day'::text NOT NULL,
    non_tailing_count integer,
    tailing_count integer
);



--
-- Name: saved_search_counters_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.saved_search_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: saved_search_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.saved_search_counters_id_seq OWNED BY _analytics.saved_search_counters.id;


--
-- Name: saved_searches; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.saved_searches (
    id bigint NOT NULL,
    querystring text,
    source_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    saved_by_user boolean,
    lql_filters jsonb,
    lql_charts jsonb,
    "tailing?" boolean DEFAULT true NOT NULL,
    tailing boolean DEFAULT true NOT NULL
);



--
-- Name: saved_searches_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.saved_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: saved_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.saved_searches_id_seq OWNED BY _analytics.saved_searches.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);



--
-- Name: source_backends; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.source_backends (
    id bigint NOT NULL,
    source_id bigint,
    type character varying(255),
    config jsonb,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: source_backends_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.source_backends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: source_backends_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.source_backends_id_seq OWNED BY _analytics.source_backends.id;


--
-- Name: source_schemas; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.source_schemas (
    id bigint NOT NULL,
    bigquery_schema bytea,
    source_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    schema_flat_map bytea
);



--
-- Name: source_schemas_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.source_schemas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: source_schemas_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.source_schemas_id_seq OWNED BY _analytics.source_schemas.id;


--
-- Name: sources; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.sources (
    id bigint NOT NULL,
    name character varying(255),
    token uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_id integer NOT NULL,
    public_token character varying(255),
    favorite boolean DEFAULT false NOT NULL,
    bigquery_table_ttl integer,
    api_quota integer DEFAULT 5 NOT NULL,
    webhook_notification_url character varying(255),
    slack_hook_url character varying(255),
    notifications jsonb DEFAULT '{"team_user_ids_for_sms": [], "team_user_ids_for_email": [], "user_text_notifications": false, "user_email_notifications": false, "other_email_notifications": null, "team_user_ids_for_schema_updates": [], "user_schema_update_notifications": true}'::jsonb NOT NULL,
    custom_event_message_keys character varying(255),
    log_events_updated_at timestamp(0) without time zone,
    bigquery_schema bytea,
    notifications_every integer DEFAULT 14400000,
    bq_table_partition_type text,
    lock_schema boolean DEFAULT false,
    validate_schema boolean DEFAULT true,
    drop_lql_filters bytea DEFAULT '\x836a'::bytea NOT NULL,
    drop_lql_string character varying(255),
    v2_pipeline boolean DEFAULT false,
    suggested_keys character varying(255) DEFAULT ''::character varying,
    service_name character varying(255),
    transform_copy_fields character varying(255),
    disable_tailing boolean DEFAULT false,
    bq_storage_write_api boolean DEFAULT false,
    bigquery_clustering_fields character varying(255),
    default_ingest_backend_enabled boolean DEFAULT false,
    system_source boolean DEFAULT false,
    system_source_type character varying(255)
);

ALTER TABLE ONLY _analytics.sources REPLICA IDENTITY FULL;



--
-- Name: sources_backends; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.sources_backends (
    id bigint NOT NULL,
    backend_id bigint,
    source_id bigint
);



--
-- Name: sources_backends_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.sources_backends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: sources_backends_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.sources_backends_id_seq OWNED BY _analytics.sources_backends.id;


--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.sources_id_seq OWNED BY _analytics.sources.id;


--
-- Name: system_metrics; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.system_metrics (
    id bigint NOT NULL,
    all_logs_logged bigint,
    node character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: system_metrics_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.system_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: system_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.system_metrics_id_seq OWNED BY _analytics.system_metrics.id;


--
-- Name: team_users; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.team_users (
    id bigint NOT NULL,
    email character varying(255),
    token text,
    provider character varying(255),
    email_preferred character varying(255),
    name character varying(255),
    image character varying(255),
    email_me_product boolean DEFAULT false NOT NULL,
    phone character varying(255),
    valid_google_account boolean DEFAULT false NOT NULL,
    provider_uid text,
    team_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    preferences jsonb
);



--
-- Name: team_users_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.team_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: team_users_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.team_users_id_seq OWNED BY _analytics.team_users.id;


--
-- Name: teams; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.teams (
    id bigint NOT NULL,
    name character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    token character varying(255) DEFAULT gen_random_uuid()
);



--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.teams_id_seq OWNED BY _analytics.teams.id;


--
-- Name: users; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.users (
    id bigint NOT NULL,
    email character varying(255),
    provider character varying(255) NOT NULL,
    token text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    api_key character varying(255) NOT NULL,
    old_api_key character varying(255),
    email_preferred character varying(255),
    name character varying(255),
    image character varying(255),
    email_me_product boolean DEFAULT true NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    phone character varying(255),
    bigquery_project_id character varying(255),
    api_quota integer DEFAULT 125 NOT NULL,
    bigquery_dataset_location character varying(255),
    bigquery_dataset_id character varying(255),
    valid_google_account boolean,
    provider_uid text NOT NULL,
    company character varying(255),
    bigquery_udfs_hash character varying(255) DEFAULT ''::character varying NOT NULL,
    bigquery_processed_bytes_limit bigint DEFAULT '10000000000'::bigint NOT NULL,
    "billing_enabled?" boolean DEFAULT false NOT NULL,
    preferences jsonb,
    billing_enabled boolean DEFAULT false NOT NULL,
    endpoints_beta boolean DEFAULT false,
    metadata jsonb,
    partner_upgraded boolean DEFAULT false,
    partner_id bigint,
    bigquery_enable_managed_service_accounts boolean DEFAULT false,
    system_monitoring boolean DEFAULT false NOT NULL,
    bigquery_reservation_search character varying(255),
    bigquery_reservation_alerts character varying(255)
);



--
-- Name: users_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.users_id_seq OWNED BY _analytics.users.id;


--
-- Name: vercel_auths; Type: TABLE; Schema: _analytics; Owner: supabase_admin
--

CREATE TABLE _analytics.vercel_auths (
    id bigint NOT NULL,
    access_token character varying(255),
    installation_id character varying(255),
    team_id character varying(255),
    token_type character varying(255),
    vercel_user_id character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: vercel_auths_id_seq; Type: SEQUENCE; Schema: _analytics; Owner: supabase_admin
--

CREATE SEQUENCE _analytics.vercel_auths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: vercel_auths_id_seq; Type: SEQUENCE OWNED BY; Schema: _analytics; Owner: supabase_admin
--

ALTER SEQUENCE _analytics.vercel_auths_id_seq OWNED BY _analytics.vercel_auths.id;


--
-- Name: cluster_tenants; Type: TABLE; Schema: _supavisor; Owner: supabase_admin
--

CREATE TABLE _supavisor.cluster_tenants (
    id uuid NOT NULL,
    type character varying(255) NOT NULL,
    active boolean DEFAULT false NOT NULL,
    cluster_alias character varying(255),
    tenant_external_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    CONSTRAINT type CHECK (((type)::text = ANY ((ARRAY['read'::character varying, 'write'::character varying])::text[])))
);



--
-- Name: clusters; Type: TABLE; Schema: _supavisor; Owner: supabase_admin
--

CREATE TABLE _supavisor.clusters (
    id uuid NOT NULL,
    active boolean DEFAULT false NOT NULL,
    alias character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);



--
-- Name: schema_migrations; Type: TABLE; Schema: _supavisor; Owner: supabase_admin
--

CREATE TABLE _supavisor.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);



--
-- Name: tenants; Type: TABLE; Schema: _supavisor; Owner: supabase_admin
--

CREATE TABLE _supavisor.tenants (
    id uuid NOT NULL,
    external_id character varying(255) NOT NULL,
    db_host character varying(255) NOT NULL,
    db_port integer NOT NULL,
    db_database character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    default_parameter_status jsonb NOT NULL,
    ip_version character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    upstream_ssl boolean DEFAULT false NOT NULL,
    upstream_verify character varying(255),
    upstream_tls_ca bytea,
    enforce_ssl boolean DEFAULT false NOT NULL,
    require_user boolean DEFAULT true NOT NULL,
    auth_query character varying(255),
    default_pool_size integer DEFAULT 15 NOT NULL,
    sni_hostname character varying(255),
    default_max_clients integer DEFAULT 1000 NOT NULL,
    client_idle_timeout integer DEFAULT 0 NOT NULL,
    default_pool_strategy character varying(255) DEFAULT 'fifo'::character varying NOT NULL,
    client_heartbeat_interval integer DEFAULT 60 NOT NULL,
    allow_list character varying(255)[] DEFAULT ARRAY['0.0.0.0/0'::character varying, '::/0'::character varying] NOT NULL,
    availability_zone character varying(255),
    feature_flags jsonb DEFAULT '{}'::jsonb,
    CONSTRAINT auth_query_constraints CHECK (((require_user = true) OR ((require_user = false) AND (auth_query IS NOT NULL)))),
    CONSTRAINT default_pool_strategy_values CHECK (((default_pool_strategy)::text = ANY ((ARRAY['fifo'::character varying, 'lifo'::character varying])::text[]))),
    CONSTRAINT ip_version_values CHECK (((ip_version)::text = ANY ((ARRAY['auto'::character varying, 'v4'::character varying, 'v6'::character varying])::text[]))),
    CONSTRAINT upstream_constraints CHECK ((((upstream_ssl = false) AND (upstream_verify IS NULL)) OR ((upstream_ssl = true) AND (upstream_verify IS NOT NULL)))),
    CONSTRAINT upstream_verify_values CHECK (((upstream_verify)::text = ANY ((ARRAY['none'::character varying, 'peer'::character varying])::text[])))
);



--
-- Name: users; Type: TABLE; Schema: _supavisor; Owner: supabase_admin
--

CREATE TABLE _supavisor.users (
    id uuid NOT NULL,
    db_user_alias character varying(255) NOT NULL,
    db_user character varying(255) NOT NULL,
    db_pass_encrypted bytea NOT NULL,
    pool_size integer NOT NULL,
    mode_type character varying(255) NOT NULL,
    is_manager boolean DEFAULT false NOT NULL,
    tenant_external_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    pool_checkout_timeout integer DEFAULT 60000 NOT NULL,
    max_clients integer
);



--
-- Name: alert_queries id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries ALTER COLUMN id SET DEFAULT nextval('_analytics.alert_queries_id_seq'::regclass);


--
-- Name: alert_queries_backends id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries_backends ALTER COLUMN id SET DEFAULT nextval('_analytics.alert_queries_backends_id_seq'::regclass);


--
-- Name: backends id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.backends ALTER COLUMN id SET DEFAULT nextval('_analytics.backends_id_seq'::regclass);


--
-- Name: billing_accounts id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.billing_accounts ALTER COLUMN id SET DEFAULT nextval('_analytics.billing_accounts_id_seq'::regclass);


--
-- Name: billing_counts id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.billing_counts ALTER COLUMN id SET DEFAULT nextval('_analytics.billing_counts_id_seq'::regclass);


--
-- Name: endpoint_queries id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.endpoint_queries ALTER COLUMN id SET DEFAULT nextval('_analytics.endpoint_queries_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('_analytics.oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('_analytics.oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_applications ALTER COLUMN id SET DEFAULT nextval('_analytics.oauth_applications_id_seq'::regclass);


--
-- Name: partner_users id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.partner_users ALTER COLUMN id SET DEFAULT nextval('_analytics.partner_users_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.partners ALTER COLUMN id SET DEFAULT nextval('_analytics.partners_id_seq'::regclass);


--
-- Name: payment_methods id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.payment_methods ALTER COLUMN id SET DEFAULT nextval('_analytics.payment_methods_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.plans ALTER COLUMN id SET DEFAULT nextval('_analytics.plans_id_seq'::regclass);


--
-- Name: rules id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.rules ALTER COLUMN id SET DEFAULT nextval('_analytics.rules_id_seq'::regclass);


--
-- Name: saved_search_counters id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.saved_search_counters ALTER COLUMN id SET DEFAULT nextval('_analytics.saved_search_counters_id_seq'::regclass);


--
-- Name: saved_searches id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.saved_searches ALTER COLUMN id SET DEFAULT nextval('_analytics.saved_searches_id_seq'::regclass);


--
-- Name: source_backends id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.source_backends ALTER COLUMN id SET DEFAULT nextval('_analytics.source_backends_id_seq'::regclass);


--
-- Name: source_schemas id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.source_schemas ALTER COLUMN id SET DEFAULT nextval('_analytics.source_schemas_id_seq'::regclass);


--
-- Name: sources id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources ALTER COLUMN id SET DEFAULT nextval('_analytics.sources_id_seq'::regclass);


--
-- Name: sources_backends id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources_backends ALTER COLUMN id SET DEFAULT nextval('_analytics.sources_backends_id_seq'::regclass);


--
-- Name: system_metrics id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.system_metrics ALTER COLUMN id SET DEFAULT nextval('_analytics.system_metrics_id_seq'::regclass);


--
-- Name: team_users id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.team_users ALTER COLUMN id SET DEFAULT nextval('_analytics.team_users_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.teams ALTER COLUMN id SET DEFAULT nextval('_analytics.teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.users ALTER COLUMN id SET DEFAULT nextval('_analytics.users_id_seq'::regclass);


--
-- Name: vercel_auths id; Type: DEFAULT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.vercel_auths ALTER COLUMN id SET DEFAULT nextval('_analytics.vercel_auths_id_seq'::regclass);


--
-- Name: alert_queries_backends alert_queries_backends_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries_backends
    ADD CONSTRAINT alert_queries_backends_pkey PRIMARY KEY (id);


--
-- Name: alert_queries alert_queries_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries
    ADD CONSTRAINT alert_queries_pkey PRIMARY KEY (id);


--
-- Name: backends backends_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.backends
    ADD CONSTRAINT backends_pkey PRIMARY KEY (id);


--
-- Name: billing_accounts billing_accounts_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.billing_accounts
    ADD CONSTRAINT billing_accounts_pkey PRIMARY KEY (id);


--
-- Name: billing_counts billing_counts_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.billing_counts
    ADD CONSTRAINT billing_counts_pkey PRIMARY KEY (id);


--
-- Name: endpoint_queries endpoint_queries_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.endpoint_queries
    ADD CONSTRAINT endpoint_queries_pkey PRIMARY KEY (id);


--
-- Name: log_events_3128584f_7988_41bc_85f0_fa872b00d1d3 log_events_3128584f_7988_41bc_85f0_fa872b00d1d3_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_3128584f_7988_41bc_85f0_fa872b00d1d3
    ADD CONSTRAINT log_events_3128584f_7988_41bc_85f0_fa872b00d1d3_pkey PRIMARY KEY (id);


--
-- Name: log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3 log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3
    ADD CONSTRAINT log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3_pkey PRIMARY KEY (id);


--
-- Name: log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23 log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23
    ADD CONSTRAINT log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23_pkey PRIMARY KEY (id);


--
-- Name: log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769 log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769
    ADD CONSTRAINT log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769_pkey PRIMARY KEY (id);


--
-- Name: log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0 log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0
    ADD CONSTRAINT log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0_pkey PRIMARY KEY (id);


--
-- Name: log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9 log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9
    ADD CONSTRAINT log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9_pkey PRIMARY KEY (id);


--
-- Name: log_events_ed300f97_837d_45ee_9949_ca82175ec020 log_events_ed300f97_837d_45ee_9949_ca82175ec020_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_ed300f97_837d_45ee_9949_ca82175ec020
    ADD CONSTRAINT log_events_ed300f97_837d_45ee_9949_ca82175ec020_pkey PRIMARY KEY (id);


--
-- Name: log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453 log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453
    ADD CONSTRAINT log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453_pkey PRIMARY KEY (id);


--
-- Name: log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7 log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7
    ADD CONSTRAINT log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: partner_users partner_users_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.partner_users
    ADD CONSTRAINT partner_users_pkey PRIMARY KEY (id);


--
-- Name: partners partners_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: rules rules_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: saved_search_counters saved_search_counters_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.saved_search_counters
    ADD CONSTRAINT saved_search_counters_pkey PRIMARY KEY (id);


--
-- Name: saved_searches saved_searches_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.saved_searches
    ADD CONSTRAINT saved_searches_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: source_backends source_backends_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.source_backends
    ADD CONSTRAINT source_backends_pkey PRIMARY KEY (id);


--
-- Name: source_schemas source_schemas_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.source_schemas
    ADD CONSTRAINT source_schemas_pkey PRIMARY KEY (id);


--
-- Name: sources_backends sources_backends_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources_backends
    ADD CONSTRAINT sources_backends_pkey PRIMARY KEY (id);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: system_metrics system_metrics_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.system_metrics
    ADD CONSTRAINT system_metrics_pkey PRIMARY KEY (id);


--
-- Name: team_users team_users_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.team_users
    ADD CONSTRAINT team_users_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vercel_auths vercel_auths_pkey; Type: CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.vercel_auths
    ADD CONSTRAINT vercel_auths_pkey PRIMARY KEY (id);


--
-- Name: cluster_tenants cluster_tenants_pkey; Type: CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.cluster_tenants
    ADD CONSTRAINT cluster_tenants_pkey PRIMARY KEY (id);


--
-- Name: clusters clusters_pkey; Type: CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: alert_queries_backends_alert_query_id_backend_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX alert_queries_backends_alert_query_id_backend_id_index ON _analytics.alert_queries_backends USING btree (alert_query_id, backend_id);


--
-- Name: alert_queries_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX alert_queries_token_index ON _analytics.alert_queries USING btree (token);


--
-- Name: alert_queries_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX alert_queries_user_id_index ON _analytics.alert_queries USING btree (user_id);


--
-- Name: billing_accounts_stripe_customer_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX billing_accounts_stripe_customer_index ON _analytics.billing_accounts USING btree (stripe_customer);


--
-- Name: billing_accounts_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX billing_accounts_user_id_index ON _analytics.billing_accounts USING btree (user_id);


--
-- Name: billing_counts_inserted_at_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX billing_counts_inserted_at_index ON _analytics.billing_counts USING btree (inserted_at);


--
-- Name: billing_counts_source_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX billing_counts_source_id_index ON _analytics.billing_counts USING btree (source_id);


--
-- Name: billing_counts_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX billing_counts_user_id_index ON _analytics.billing_counts USING btree (user_id);


--
-- Name: endpoint_queries_backend_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX endpoint_queries_backend_id_index ON _analytics.endpoint_queries USING btree (backend_id);


--
-- Name: endpoint_queries_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX endpoint_queries_token_index ON _analytics.endpoint_queries USING btree (token);


--
-- Name: endpoint_queries_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX endpoint_queries_user_id_index ON _analytics.endpoint_queries USING btree (user_id);


--
-- Name: idx_backends_default_ingest; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX idx_backends_default_ingest ON _analytics.backends USING btree (default_ingest) WHERE (default_ingest = true);


--
-- Name: log_events_3128584f_7988_41bc_85f0_fa872b00d1d3_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_3128584f_7988_41bc_85f0_fa872b00d1d3_timestamp_brin_ ON _analytics.log_events_3128584f_7988_41bc_85f0_fa872b00d1d3 USING brin ("timestamp");


--
-- Name: log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3_timestamp_brin_ ON _analytics.log_events_43c242d4_6898_41f3_83bc_99a2761c1ec3 USING brin ("timestamp");


--
-- Name: log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23_timestamp_brin_ ON _analytics.log_events_4467d0cb_5427_4a3e_aa63_a7d619618a23 USING brin ("timestamp");


--
-- Name: log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769_timestamp_brin_ ON _analytics.log_events_65b5c9f7_8a66_42fe_9cf0_5a122169f769 USING brin ("timestamp");


--
-- Name: log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0_timestamp_brin_ ON _analytics.log_events_77faac68_3aa7_4d8e_9df6_4d0ebdcf2ea0 USING brin ("timestamp");


--
-- Name: log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9_timestamp_brin_ ON _analytics.log_events_86817dc2_02d9_47cc_9f8a_25d5d07d45c9 USING brin ("timestamp");


--
-- Name: log_events_ed300f97_837d_45ee_9949_ca82175ec020_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_ed300f97_837d_45ee_9949_ca82175ec020_timestamp_brin_ ON _analytics.log_events_ed300f97_837d_45ee_9949_ca82175ec020 USING brin ("timestamp");


--
-- Name: log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453_timestamp_brin_ ON _analytics.log_events_ed7a95e3_5230_42e4_83e3_ea45ace3b453 USING brin ("timestamp");


--
-- Name: log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7_timestamp_brin_; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7_timestamp_brin_ ON _analytics.log_events_f6f694b9_e613_4ccb_9298_82f8bb4cefb7 USING brin ("timestamp");


--
-- Name: oauth_access_grants_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX oauth_access_grants_token_index ON _analytics.oauth_access_grants USING btree (token);


--
-- Name: oauth_access_tokens_refresh_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX oauth_access_tokens_refresh_token_index ON _analytics.oauth_access_tokens USING btree (refresh_token);


--
-- Name: oauth_access_tokens_resource_owner_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX oauth_access_tokens_resource_owner_id_index ON _analytics.oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: oauth_access_tokens_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX oauth_access_tokens_token_index ON _analytics.oauth_access_tokens USING btree (token);


--
-- Name: oauth_applications_owner_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX oauth_applications_owner_id_index ON _analytics.oauth_applications USING btree (owner_id);


--
-- Name: oauth_applications_uid_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX oauth_applications_uid_index ON _analytics.oauth_applications USING btree (uid);


--
-- Name: partner_users_partner_id_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX partner_users_partner_id_user_id_index ON _analytics.partner_users USING btree (partner_id, user_id);


--
-- Name: partner_users_partner_id_user_id_upgraded_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX partner_users_partner_id_user_id_upgraded_index ON _analytics.partner_users USING btree (partner_id, user_id, upgraded);


--
-- Name: payment_methods_customer_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX payment_methods_customer_id_index ON _analytics.payment_methods USING btree (customer_id);


--
-- Name: payment_methods_stripe_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX payment_methods_stripe_id_index ON _analytics.payment_methods USING btree (stripe_id);


--
-- Name: rules_source_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX rules_source_id_index ON _analytics.rules USING btree (source_id);


--
-- Name: rules_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX rules_token_index ON _analytics.rules USING btree (token);


--
-- Name: saved_search_counters_timestamp_saved_search_id_granularity_ind; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX saved_search_counters_timestamp_saved_search_id_granularity_ind ON _analytics.saved_search_counters USING btree ("timestamp", saved_search_id, granularity);


--
-- Name: saved_searches_querystring_source_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX saved_searches_querystring_source_id_index ON _analytics.saved_searches USING btree (querystring, source_id);


--
-- Name: source_schemas_source_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX source_schemas_source_id_index ON _analytics.source_schemas USING btree (source_id);


--
-- Name: sources_name_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX sources_name_index ON _analytics.sources USING btree (id, name);


--
-- Name: sources_public_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX sources_public_token_index ON _analytics.sources USING btree (public_token);


--
-- Name: sources_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX sources_token_index ON _analytics.sources USING btree (token);


--
-- Name: sources_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX sources_user_id_index ON _analytics.sources USING btree (user_id);


--
-- Name: sources_user_id_system_source_type_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX sources_user_id_system_source_type_index ON _analytics.sources USING btree (user_id, system_source_type);


--
-- Name: system_metrics_node_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX system_metrics_node_index ON _analytics.system_metrics USING btree (node);


--
-- Name: team_users_provider_uid_team_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX team_users_provider_uid_team_id_index ON _analytics.team_users USING btree (provider_uid, team_id);


--
-- Name: team_users_team_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX team_users_team_id_index ON _analytics.team_users USING btree (team_id);


--
-- Name: teams_token_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX teams_token_index ON _analytics.teams USING btree (token);


--
-- Name: teams_user_id_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX teams_user_id_index ON _analytics.teams USING btree (user_id);


--
-- Name: users_api_key_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE INDEX users_api_key_index ON _analytics.users USING btree (api_key);


--
-- Name: users_lower_email_index; Type: INDEX; Schema: _analytics; Owner: supabase_admin
--

CREATE UNIQUE INDEX users_lower_email_index ON _analytics.users USING btree (lower((email)::text));


--
-- Name: cluster_tenants_tenant_external_id_index; Type: INDEX; Schema: _supavisor; Owner: supabase_admin
--

CREATE UNIQUE INDEX cluster_tenants_tenant_external_id_index ON _supavisor.cluster_tenants USING btree (tenant_external_id);


--
-- Name: clusters_alias_index; Type: INDEX; Schema: _supavisor; Owner: supabase_admin
--

CREATE UNIQUE INDEX clusters_alias_index ON _supavisor.clusters USING btree (alias);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _supavisor; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _supavisor.tenants USING btree (external_id);


--
-- Name: users_db_user_alias_tenant_external_id_mode_type_index; Type: INDEX; Schema: _supavisor; Owner: supabase_admin
--

CREATE UNIQUE INDEX users_db_user_alias_tenant_external_id_mode_type_index ON _supavisor.users USING btree (db_user_alias, tenant_external_id, mode_type);


--
-- Name: alert_queries_backends alert_queries_backends_alert_query_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries_backends
    ADD CONSTRAINT alert_queries_backends_alert_query_id_fkey FOREIGN KEY (alert_query_id) REFERENCES _analytics.alert_queries(id) ON DELETE CASCADE;


--
-- Name: alert_queries_backends alert_queries_backends_backend_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries_backends
    ADD CONSTRAINT alert_queries_backends_backend_id_fkey FOREIGN KEY (backend_id) REFERENCES _analytics.backends(id) ON DELETE CASCADE;


--
-- Name: alert_queries alert_queries_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.alert_queries
    ADD CONSTRAINT alert_queries_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: backends backends_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.backends
    ADD CONSTRAINT backends_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id);


--
-- Name: billing_accounts billing_accounts_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.billing_accounts
    ADD CONSTRAINT billing_accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: billing_counts billing_counts_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.billing_counts
    ADD CONSTRAINT billing_counts_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: endpoint_queries endpoint_queries_backend_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.endpoint_queries
    ADD CONSTRAINT endpoint_queries_backend_id_fkey FOREIGN KEY (backend_id) REFERENCES _analytics.backends(id) ON DELETE SET NULL;


--
-- Name: endpoint_queries endpoint_queries_sandbox_query_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.endpoint_queries
    ADD CONSTRAINT endpoint_queries_sandbox_query_id_fkey FOREIGN KEY (sandbox_query_id) REFERENCES _analytics.endpoint_queries(id);


--
-- Name: endpoint_queries endpoint_queries_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.endpoint_queries
    ADD CONSTRAINT endpoint_queries_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: oauth_access_grants oauth_access_grants_application_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_application_id_fkey FOREIGN KEY (application_id) REFERENCES _analytics.oauth_applications(id);


--
-- Name: oauth_access_tokens oauth_access_tokens_application_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_application_id_fkey FOREIGN KEY (application_id) REFERENCES _analytics.oauth_applications(id);


--
-- Name: partner_users partner_users_partner_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.partner_users
    ADD CONSTRAINT partner_users_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES _analytics.partners(id);


--
-- Name: partner_users partner_users_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.partner_users
    ADD CONSTRAINT partner_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: payment_methods payment_methods_customer_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.payment_methods
    ADD CONSTRAINT payment_methods_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES _analytics.billing_accounts(stripe_customer) ON DELETE CASCADE;


--
-- Name: rules rules_backend_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.rules
    ADD CONSTRAINT rules_backend_id_fkey FOREIGN KEY (backend_id) REFERENCES _analytics.backends(id) ON DELETE CASCADE;


--
-- Name: rules rules_sink_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.rules
    ADD CONSTRAINT rules_sink_fkey FOREIGN KEY (sink) REFERENCES _analytics.sources(token) ON DELETE CASCADE;


--
-- Name: rules rules_source_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.rules
    ADD CONSTRAINT rules_source_id_fkey FOREIGN KEY (source_id) REFERENCES _analytics.sources(id) ON DELETE CASCADE;


--
-- Name: saved_search_counters saved_search_counters_saved_search_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.saved_search_counters
    ADD CONSTRAINT saved_search_counters_saved_search_id_fkey FOREIGN KEY (saved_search_id) REFERENCES _analytics.saved_searches(id) ON DELETE CASCADE;


--
-- Name: saved_searches saved_searches_source_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.saved_searches
    ADD CONSTRAINT saved_searches_source_id_fkey FOREIGN KEY (source_id) REFERENCES _analytics.sources(id) ON DELETE CASCADE;


--
-- Name: source_backends source_backends_source_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.source_backends
    ADD CONSTRAINT source_backends_source_id_fkey FOREIGN KEY (source_id) REFERENCES _analytics.sources(id);


--
-- Name: source_schemas source_schemas_source_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.source_schemas
    ADD CONSTRAINT source_schemas_source_id_fkey FOREIGN KEY (source_id) REFERENCES _analytics.sources(id) ON DELETE CASCADE;


--
-- Name: sources_backends sources_backends_backend_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources_backends
    ADD CONSTRAINT sources_backends_backend_id_fkey FOREIGN KEY (backend_id) REFERENCES _analytics.backends(id);


--
-- Name: sources_backends sources_backends_source_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources_backends
    ADD CONSTRAINT sources_backends_source_id_fkey FOREIGN KEY (source_id) REFERENCES _analytics.sources(id);


--
-- Name: sources sources_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.sources
    ADD CONSTRAINT sources_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: team_users team_users_team_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.team_users
    ADD CONSTRAINT team_users_team_id_fkey FOREIGN KEY (team_id) REFERENCES _analytics.teams(id) ON DELETE CASCADE;


--
-- Name: teams teams_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.teams
    ADD CONSTRAINT teams_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: users users_partner_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.users
    ADD CONSTRAINT users_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES _analytics.partners(id);


--
-- Name: vercel_auths vercel_auths_user_id_fkey; Type: FK CONSTRAINT; Schema: _analytics; Owner: supabase_admin
--

ALTER TABLE ONLY _analytics.vercel_auths
    ADD CONSTRAINT vercel_auths_user_id_fkey FOREIGN KEY (user_id) REFERENCES _analytics.users(id) ON DELETE CASCADE;


--
-- Name: cluster_tenants cluster_tenants_cluster_alias_fkey; Type: FK CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.cluster_tenants
    ADD CONSTRAINT cluster_tenants_cluster_alias_fkey FOREIGN KEY (cluster_alias) REFERENCES _supavisor.clusters(alias) ON DELETE CASCADE;


--
-- Name: cluster_tenants cluster_tenants_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.cluster_tenants
    ADD CONSTRAINT cluster_tenants_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _supavisor.tenants(external_id);


--
-- Name: users users_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _supavisor; Owner: supabase_admin
--

ALTER TABLE ONLY _supavisor.users
    ADD CONSTRAINT users_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _supavisor.tenants(external_id) ON DELETE CASCADE;


--
-- Name: logflare_pub; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION logflare_pub WITH (publish = 'insert, update, delete, truncate');



--
-- Name: logflare_pub backends; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.backends;


--
-- Name: logflare_pub billing_accounts; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.billing_accounts;


--
-- Name: logflare_pub oauth_access_tokens; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.oauth_access_tokens;


--
-- Name: logflare_pub plans; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.plans;


--
-- Name: logflare_pub rules; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.rules;


--
-- Name: logflare_pub source_schemas; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.source_schemas;


--
-- Name: logflare_pub sources; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.sources;


--
-- Name: logflare_pub team_users; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.team_users;


--
-- Name: logflare_pub users; Type: PUBLICATION TABLE; Schema: _analytics; Owner: supabase_admin
--

ALTER PUBLICATION logflare_pub ADD TABLE ONLY _analytics.users;


--
-- PostgreSQL database dump complete
--

