CREATE TABLE public.coupon_eligible_customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    mobile_number character varying(20) NOT NULL,
    customer_name character varying(255),
    import_batch_id uuid,
    imported_at timestamp with time zone DEFAULT now(),
    imported_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: coupon_products; Type: TABLE; Schema: public; Owner: -
--

