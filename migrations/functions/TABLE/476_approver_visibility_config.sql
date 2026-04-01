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

