CREATE TABLE public.users (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    quick_access_code character varying(255) NOT NULL,
    quick_access_salt character varying(100) NOT NULL,
    user_type public.user_type_enum DEFAULT 'branch_specific'::public.user_type_enum NOT NULL,
    employee_id uuid,
    branch_id bigint,
    position_id uuid,
    avatar text,
    avatar_small_url text,
    avatar_medium_url text,
    avatar_large_url text,
    is_first_login boolean DEFAULT true,
    failed_login_attempts integer DEFAULT 0,
    locked_at timestamp with time zone,
    locked_by uuid,
    last_login_at timestamp with time zone,
    password_expires_at timestamp with time zone,
    last_password_change timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    ai_translation_enabled boolean DEFAULT false NOT NULL,
    is_master_admin boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    CONSTRAINT users_employee_branch_check CHECK (((user_type = 'global'::public.user_type_enum) OR ((user_type = 'branch_specific'::public.user_type_enum) AND (branch_id IS NOT NULL))))
);


--
-- Name: COLUMN users.ai_translation_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.ai_translation_enabled IS 'Whether AI translation is enabled for this user - controls access to AI translation features in mobile interface';


--
-- Name: quick_task_completion_details; Type: VIEW; Schema: public; Owner: -
--

