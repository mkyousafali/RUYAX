CREATE FUNCTION public.get_customer_products_with_offers(p_branch_id text DEFAULT NULL::text, p_service_type text DEFAULT 'both'::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result json;
  v_now timestamptz := NOW();
BEGIN
  WITH
  -- Step 1: Get active offers filtered by branch and service type
  active_offers AS (
    SELECT *
    FROM offers o
    WHERE o.is_active = true
      AND o.type IN ('product', 'bogo', 'bundle')
      AND o.start_date <= v_now
      AND o.end_date >= v_now
      AND (o.branch_id IS NULL OR o.branch_id::text = p_branch_id)
      AND (o.service_type IS NULL OR o.service_type = 'both' OR o.service_type = p_service_type)
  ),

  -- Step 2: Get offer products with enriched product + offer data
  enriched_offer_products AS (
    SELECT
      p.id,
      p.barcode,
      p.product_name_en AS "nameEn",
      p.product_name_ar AS "nameAr",
      p.category_id AS category,
      COALESCE(pc.name_en, 'Uncategorized') AS "categoryNameEn",
      COALESCE(pc.name_ar, '╪║┘è╪▒ ┘à╪╡┘å┘ü') AS "categoryNameAr",
      p.image_url AS image,
      p.current_stock AS stock,
      p.minimum_qty_alert AS "lowStockThreshold",
      COALESCE(pu.name_en, 'Unit') AS "unitEn",
      COALESCE(pu.name_ar, '┘ê╪¡╪»╪⌐') AS "unitAr",
      COALESCE(p.unit_qty, 1) AS "unitQty",
      p.sale_price::float AS "originalPrice",
      -- Calculate offer price
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN
          (p.sale_price - (p.sale_price * op.offer_percentage / 100))::float
        WHEN op.offer_price IS NOT NULL AND op.offer_price > 0 THEN
          op.offer_price::float
        ELSE NULL
      END AS "offerPrice",
      -- Calculate savings
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN
          (p.sale_price * op.offer_percentage / 100)::float
        WHEN op.offer_price IS NOT NULL AND op.offer_price > 0 THEN
          (p.sale_price - op.offer_price)::float
        ELSE 0
      END AS savings,
      -- Calculate discount percentage
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN
          op.offer_percentage::float
        WHEN op.offer_price IS NOT NULL AND op.offer_price > 0 THEN
          ROUND(((p.sale_price - op.offer_price) / NULLIF(p.sale_price, 0) * 100))::float
        ELSE 0
      END AS "discountPercentage",
      true AS "hasOffer",
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN 'percentage'
        ELSE 'special_price'
      END AS "offerType",
      ao.id AS "offerId",
      ao.name_en AS "offerNameEn",
      ao.name_ar AS "offerNameAr",
      op.offer_qty AS "offerQty",
      op.max_uses AS "maxUses",
      ao.end_date AS "offerEndDate",
      CASE
        WHEN EXTRACT(EPOCH FROM (ao.end_date - v_now)) / 3600 BETWEEN 0 AND 24 THEN true
        ELSE false
      END AS "isExpiringSoon"
    FROM offer_products op
    JOIN active_offers ao ON ao.id = op.offer_id
    JOIN products p ON p.id = op.product_id
    LEFT JOIN product_categories pc ON pc.id = p.category_id
    LEFT JOIN product_units pu ON pu.id = p.unit_id
    WHERE p.is_active = true
      AND p.is_customer_product = true
      AND (
        (op.offer_percentage IS NOT NULL AND op.offer_percentage > 0)
        OR (op.offer_price IS NOT NULL AND op.offer_price > 0)
      )
  ),

  -- Step 3: Get all active customer products (non-offer)
  all_products AS (
    SELECT
      p.id,
      p.barcode,
      p.product_name_en AS "nameEn",
      p.product_name_ar AS "nameAr",
      p.category_id AS category,
      COALESCE(pc.name_en, 'Uncategorized') AS "categoryNameEn",
      COALESCE(pc.name_ar, '╪║┘è╪▒ ┘à╪╡┘å┘ü') AS "categoryNameAr",
      p.image_url AS image,
      p.current_stock AS stock,
      p.minimum_qty_alert AS "lowStockThreshold",
      COALESCE(pu.name_en, 'Unit') AS "unitEn",
      COALESCE(pu.name_ar, '┘ê╪¡╪»╪⌐') AS "unitAr",
      COALESCE(p.unit_qty, 1) AS "unitQty",
      p.sale_price::float AS "originalPrice",
      NULL::float AS "offerPrice",
      0::float AS savings,
      0::float AS "discountPercentage",
      false AS "hasOffer",
      NULL::text AS "offerType",
      NULL::int AS "offerId",
      NULL::text AS "offerNameEn",
      NULL::text AS "offerNameAr",
      NULL::int AS "offerQty",
      NULL::int AS "maxUses",
      NULL::timestamptz AS "offerEndDate",
      false AS "isExpiringSoon"
    FROM products p
    LEFT JOIN product_categories pc ON pc.id = p.category_id
    LEFT JOIN product_units pu ON pu.id = p.unit_id
    WHERE p.is_active = true
      AND p.is_customer_product = true
      AND p.id NOT IN (SELECT id FROM enriched_offer_products)
  ),

  -- Combine offer products + regular products
  combined_products AS (
    SELECT * FROM enriched_offer_products
    UNION ALL
    SELECT * FROM all_products
  ),

  -- Step 4: Build BOGO offer cards
  bogo_cards AS (
    SELECT
      json_build_object(
        'id', 'bogo-' || bor.id,
        'type', 'bogo_offer',
        'offerId', ao.id,
        'offerNameEn', ao.name_en,
        'offerNameAr', ao.name_ar,
        'isExpiringSoon', CASE
          WHEN EXTRACT(EPOCH FROM (ao.end_date - v_now)) / 3600 BETWEEN 0 AND 24 THEN true
          ELSE false
        END,
        'offerEndDate', ao.end_date,
        'buyProduct', json_build_object(
          'id', bp.id,
          'nameEn', bp.product_name_en,
          'nameAr', bp.product_name_ar,
          'image', bp.image_url,
          'unitEn', COALESCE(bpu.name_en, 'Unit'),
          'unitAr', COALESCE(bpu.name_ar, '┘ê╪¡╪»╪⌐'),
          'unitQty', COALESCE(bp.unit_qty, 1),
          'price', bp.sale_price::float,
          'quantity', bor.buy_quantity,
          'stock', bp.current_stock,
          'lowStockThreshold', bp.minimum_qty_alert,
          'barcode', bp.barcode,
          'category', bp.category_id,
          'categoryNameEn', COALESCE(bpc.name_en, 'Uncategorized'),
          'categoryNameAr', COALESCE(bpc.name_ar, '╪║┘è╪▒ ┘à╪╡┘å┘ü')
        ),
        'getProduct', json_build_object(
          'id', gp.id,
          'nameEn', gp.product_name_en,
          'nameAr', gp.product_name_ar,
          'image', gp.image_url,
          'unitEn', COALESCE(gpu.name_en, 'Unit'),
          'unitAr', COALESCE(gpu.name_ar, '┘ê╪¡╪»╪⌐'),
          'unitQty', COALESCE(gp.unit_qty, 1),
          'originalPrice', gp.sale_price::float,
          'offerPrice', CASE
            WHEN bor.discount_type = 'free' THEN 0::float
            WHEN bor.discount_type = 'percentage' AND bor.discount_value IS NOT NULL THEN
              (gp.sale_price - (gp.sale_price * bor.discount_value / 100))::float
            ELSE gp.sale_price::float
          END,
          'quantity', bor.get_quantity,
          'isFree', (bor.discount_type = 'free'),
          'discountPercentage', CASE
            WHEN bor.discount_type = 'free' THEN 100::float
            WHEN bor.discount_type = 'percentage' THEN bor.discount_value::float
            ELSE 0::float
          END,
          'stock', gp.current_stock,
          'lowStockThreshold', gp.minimum_qty_alert,
          'barcode', gp.barcode,
          'category', gp.category_id,
          'categoryNameEn', COALESCE(gpc.name_en, 'Uncategorized'),
          'categoryNameAr', COALESCE(gpc.name_ar, '╪║┘è╪▒ ┘à╪╡┘å┘ü')
        ),
        'bundlePrice', (bp.sale_price * bor.buy_quantity +
          CASE
            WHEN bor.discount_type = 'free' THEN 0
            WHEN bor.discount_type = 'percentage' THEN (gp.sale_price - (gp.sale_price * bor.discount_value / 100)) * bor.get_quantity
            ELSE gp.sale_price * bor.get_quantity
          END)::float,
        'originalBundlePrice', (bp.sale_price * bor.buy_quantity + gp.sale_price * bor.get_quantity)::float,
        'savings', (CASE
            WHEN bor.discount_type = 'free' THEN gp.sale_price * bor.get_quantity
            WHEN bor.discount_type = 'percentage' THEN (gp.sale_price * bor.discount_value / 100) * bor.get_quantity
            ELSE 0
          END)::float
      ) AS bogo_card
    FROM bogo_offer_rules bor
    JOIN active_offers ao ON ao.id = bor.offer_id
    JOIN products bp ON bp.id = bor.buy_product_id
    JOIN products gp ON gp.id = bor.get_product_id
    LEFT JOIN product_units bpu ON bpu.id = bp.unit_id
    LEFT JOIN product_units gpu ON gpu.id = gp.unit_id
    LEFT JOIN product_categories bpc ON bpc.id = bp.category_id
    LEFT JOIN product_categories gpc ON gpc.id = gp.category_id
    WHERE bp.is_active = true
      AND gp.is_active = true
  ),

  -- Step 5: Build bundle offer cards
  bundle_data AS (
    SELECT
      ob.id AS bundle_id,
      ao.id AS offer_id,
      ao.name_en AS offer_name_en,
      ao.name_ar AS offer_name_ar,
      ao.end_date,
      ob.bundle_name_en,
      ob.bundle_name_ar,
      ob.required_products,
      ob.discount_type,
      ob.discount_value,
      CASE
        WHEN EXTRACT(EPOCH FROM (ao.end_date - v_now)) / 3600 BETWEEN 0 AND 24 THEN true
        ELSE false
      END AS is_expiring_soon
    FROM offer_bundles ob
    JOIN active_offers ao ON ao.id = ob.offer_id
  ),

  bundle_products_expanded AS (
    SELECT
      bd.bundle_id,
      bd.offer_id,
      bd.offer_name_en,
      bd.offer_name_ar,
      bd.end_date,
      bd.bundle_name_en,
      bd.bundle_name_ar,
      bd.discount_type,
      bd.discount_value,
      bd.is_expiring_soon,
      elem->>'product_id' AS req_product_id,
      COALESCE((elem->>'quantity')::int, 1) AS req_quantity,
      p.id AS product_id,
      p.product_name_en,
      p.product_name_ar,
      p.image_url,
      p.sale_price::float AS price,
      COALESCE(p.unit_qty, 1) AS unit_qty,
      p.current_stock AS stock,
      p.barcode,
      COALESCE(pu.name_en, 'Unit') AS unit_en,
      COALESCE(pu.name_ar, '┘ê╪¡╪»╪⌐') AS unit_ar,
      p.unit_id
    FROM bundle_data bd,
    LATERAL jsonb_array_elements(bd.required_products) AS elem
    LEFT JOIN products p ON p.id = (elem->>'product_id')
    LEFT JOIN product_units pu ON pu.id = p.unit_id
    WHERE p.is_customer_product = true
  ),

  bundle_cards AS (
    SELECT
      bpe.bundle_id,
      json_build_object(
        'offerId', bpe.offer_id,
        'offerNameEn', bpe.offer_name_en,
        'offerNameAr', bpe.offer_name_ar,
        'offerType', 'bundle',
        'bundleName', bpe.bundle_name_en,
        'bundleProducts', json_agg(
          json_build_object(
            'id', bpe.product_id,
            'unitId', bpe.unit_id,
            'nameEn', bpe.product_name_en,
            'nameAr', bpe.product_name_ar,
            'image', bpe.image_url,
            'price', bpe.price,
            'quantity', bpe.req_quantity,
            'unitQty', bpe.unit_qty,
            'unitEn', bpe.unit_en,
            'unitAr', bpe.unit_ar,
            'stock', bpe.stock,
            'barcode', bpe.barcode
          )
        ),
        'originalBundlePrice', SUM(bpe.price * bpe.req_quantity),
        'bundlePrice', CASE
          WHEN bpe.discount_type = 'percentage' THEN
            SUM(bpe.price * bpe.req_quantity) * (1 - bpe.discount_value::float / 100)
          WHEN bpe.discount_type = 'amount' THEN
            bpe.discount_value::float
          ELSE
            GREATEST(0, SUM(bpe.price * bpe.req_quantity) - bpe.discount_value::float)
        END,
        'savings', CASE
          WHEN bpe.discount_type = 'percentage' THEN
            SUM(bpe.price * bpe.req_quantity) * (bpe.discount_value::float / 100)
          WHEN bpe.discount_type = 'amount' THEN
            SUM(bpe.price * bpe.req_quantity) - bpe.discount_value::float
          ELSE
            bpe.discount_value::float
        END,
        'discountType', bpe.discount_type,
        'discountValue', bpe.discount_value::float,
        'offerEndDate', bpe.end_date,
        'isExpiringSoon', bpe.is_expiring_soon
      ) AS bundle_card
    FROM bundle_products_expanded bpe
    GROUP BY bpe.bundle_id, bpe.offer_id, bpe.offer_name_en, bpe.offer_name_ar,
             bpe.bundle_name_en, bpe.bundle_name_ar, bpe.discount_type,
             bpe.discount_value, bpe.end_date, bpe.is_expiring_soon
  )

  -- Final: Build the complete result
  SELECT json_build_object(
    'products', COALESCE((SELECT json_agg(
      json_build_object(
        'id', cp.id,
        'barcode', cp.barcode,
        'nameEn', cp."nameEn",
        'nameAr', cp."nameAr",
        'category', cp.category,
        'categoryNameEn', cp."categoryNameEn",
        'categoryNameAr', cp."categoryNameAr",
        'image', cp.image,
        'stock', cp.stock,
        'lowStockThreshold', cp."lowStockThreshold",
        'unitEn', cp."unitEn",
        'unitAr', cp."unitAr",
        'unitQty', cp."unitQty",
        'originalPrice', cp."originalPrice",
        'offerPrice', cp."offerPrice",
        'savings', cp.savings,
        'discountPercentage', cp."discountPercentage",
        'hasOffer', cp."hasOffer",
        'offerType', cp."offerType",
        'offerId', cp."offerId",
        'offerNameEn', cp."offerNameEn",
        'offerNameAr', cp."offerNameAr",
        'offerQty', cp."offerQty",
        'maxUses', cp."maxUses",
        'offerEndDate', cp."offerEndDate",
        'isExpiringSoon', cp."isExpiringSoon"
      )
    ) FROM combined_products cp), '[]'::json),
    'bogoOffers', COALESCE((SELECT json_agg(bc.bogo_card) FROM bogo_cards bc), '[]'::json),
    'bundleOffers', COALESCE((SELECT json_agg(bc.bundle_card) FROM bundle_cards bc), '[]'::json),
    'offersCount', (SELECT COUNT(*) FROM active_offers)
  ) INTO v_result;

  RETURN v_result;
END;
$$;


--
-- Name: get_customer_requests_with_details(); Type: FUNCTION; Schema: public; Owner: -
--

