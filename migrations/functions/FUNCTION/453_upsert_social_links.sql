CREATE FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text DEFAULT NULL::text, _whatsapp text DEFAULT NULL::text, _instagram text DEFAULT NULL::text, _tiktok text DEFAULT NULL::text, _snapchat text DEFAULT NULL::text, _website text DEFAULT NULL::text, _location_link text DEFAULT NULL::text) RETURNS TABLE(id uuid, branch_id bigint, facebook text, whatsapp text, instagram text, tiktok text, snapchat text, website text, location_link text, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE sql
    AS $$
  INSERT INTO public.social_links (branch_id, facebook, whatsapp, instagram, tiktok, snapchat, website, location_link)
  VALUES (_branch_id, _facebook, _whatsapp, _instagram, _tiktok, _snapchat, _website, _location_link)
  ON CONFLICT (branch_id) DO UPDATE SET
    facebook = _facebook,
    whatsapp = _whatsapp,
    instagram = _instagram,
    tiktok = _tiktok,
    snapchat = _snapchat,
    website = _website,
    location_link = _location_link,
    updated_at = NOW()
  RETURNING id, branch_id, facebook, whatsapp, instagram, tiktok, snapchat, website, location_link, created_at, updated_at
$$;


--
-- Name: validate_break_code(text); Type: FUNCTION; Schema: public; Owner: -
--

