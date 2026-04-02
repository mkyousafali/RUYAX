CREATE TABLE public.approver_branch_access (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    branch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT approver_branch_access_active_check CHECK (((is_active = true) OR (is_active = false)))
);


--
-- Name: approver_branch_access_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

