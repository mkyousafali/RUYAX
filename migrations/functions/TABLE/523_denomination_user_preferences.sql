CREATE TABLE public.denomination_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE denomination_user_preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_user_preferences IS 'Stores user preferences for the Denomination feature';


--
-- Name: COLUMN denomination_user_preferences.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_user_preferences.user_id IS 'Reference to the user';


--
-- Name: COLUMN denomination_user_preferences.default_branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_user_preferences.default_branch_id IS 'Default branch selected by the user for denomination';


--
-- Name: desktop_themes; Type: TABLE; Schema: public; Owner: -
--

