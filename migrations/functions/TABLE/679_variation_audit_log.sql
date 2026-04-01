CREATE TABLE public.variation_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type text NOT NULL,
    variation_group_id uuid,
    affected_barcodes text[],
    parent_barcode text,
    group_name_en text,
    group_name_ar text,
    user_id uuid,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT variation_audit_log_action_type_check CHECK ((action_type = ANY (ARRAY['create_group'::text, 'edit_group'::text, 'delete_group'::text, 'add_variation'::text, 'remove_variation'::text, 'reorder_variations'::text, 'change_parent'::text, 'update_image_override'::text])))
);


--
-- Name: TABLE variation_audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.variation_audit_log IS 'Audit trail for all variation group operations';


--
-- Name: COLUMN variation_audit_log.action_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.action_type IS 'Type of action performed on variation group';


--
-- Name: COLUMN variation_audit_log.variation_group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.variation_group_id IS 'UUID of the variation group affected';


--
-- Name: COLUMN variation_audit_log.affected_barcodes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.affected_barcodes IS 'Array of product barcodes affected by this action';


--
-- Name: COLUMN variation_audit_log.parent_barcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.parent_barcode IS 'Parent product barcode for reference';


--
-- Name: COLUMN variation_audit_log.group_name_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.group_name_en IS 'English name of the group at time of action';


--
-- Name: COLUMN variation_audit_log.group_name_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.group_name_ar IS 'Arabic name of the group at time of action';


--
-- Name: COLUMN variation_audit_log.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.user_id IS 'User who performed the action';


--
-- Name: COLUMN variation_audit_log.details; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.variation_audit_log.details IS 'Additional details stored as JSON (before/after state, etc.)';


--
-- Name: vendor_payment_schedule; Type: TABLE; Schema: public; Owner: -
--

