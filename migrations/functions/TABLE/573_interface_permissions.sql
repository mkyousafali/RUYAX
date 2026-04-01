CREATE TABLE public.interface_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    desktop_enabled boolean DEFAULT true NOT NULL,
    mobile_enabled boolean DEFAULT true NOT NULL,
    customer_enabled boolean DEFAULT false NOT NULL,
    updated_by uuid NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    cashier_enabled boolean DEFAULT false
);


--
-- Name: TABLE interface_permissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.interface_permissions IS 'User access permissions for different application interfaces';


--
-- Name: COLUMN interface_permissions.desktop_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.interface_permissions.desktop_enabled IS 'Whether user can access desktop interface';


--
-- Name: COLUMN interface_permissions.mobile_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.interface_permissions.mobile_enabled IS 'Whether user can access mobile interface';


--
-- Name: COLUMN interface_permissions.customer_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.interface_permissions.customer_enabled IS 'Whether user can access customer interface';


--
-- Name: COLUMN interface_permissions.cashier_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.interface_permissions.cashier_enabled IS 'Controls access to the cashier/POS application';


--
-- Name: lease_rent_lease_parties; Type: TABLE; Schema: public; Owner: -
--

