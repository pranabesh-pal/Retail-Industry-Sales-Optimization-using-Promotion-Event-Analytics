WITH cte1 AS(
	SELECT
		dc.campaign_name,
		SUM(base_price * "quantity_sold(before_promo)") AS revenue_before,
		SUM(
			CASE
				WHEN promo_type = '25% OFF'
					THEN (base_price * 0.75) * "quantity_sold(after_promo)"
	
				WHEN promo_type = '33% OFF'
					THEN (base_price * 0.67) * "quantity_sold(after_promo)"
	
				WHEN promo_type = '50% OFF'
					THEN (base_price * 0.50) * "quantity_sold(after_promo)"
	
				WHEN promo_type = 'BOGOF'
					THEN (base_price * 1) * "quantity_sold(after_promo)"
	
				WHEN promo_type = '500 CASHBACK'
					THEN (base_price - 500) * "quantity_sold(after_promo)"	
				END) AS revenue_after,
		SUM("quantity_sold(before_promo)") AS total_sales_qty_before,
    	SUM("quantity_sold(after_promo)") AS total_sales_qty_after
	FROM fact_events fe
	INNER JOIN dim_campaigns dc 
		ON fe.campaign_id = dc.campaign_id
	GROUP BY dc.campaign_name
),

cte2 AS(
	SELECT
		campaign_name,									
		total_sales_qty_before,
		total_sales_qty_after,
		total_sales_qty_after - total_sales_qty_before AS incremental_sales_qty,
		revenue_before,
		revenue_after,
		revenue_after - revenue_before AS incremental_revenue
	FROM cte1
)

SELECT
	campaign_name,									
	total_sales_qty_before,
	total_sales_qty_after,
	incremental_sales_qty,
	ROUND((incremental_sales_qty/total_sales_qty_before) * 100, 2) AS "incremental_sales_qty%",
	ROUND(revenue_before / 1000000, 2) AS revenue_before_mln,
	ROUND(revenue_after / 1000000, 2) AS revenue_after_mln,
	ROUND(incremental_revenue / 1000000, 2) AS incremental_revenue_mln,
	ROUND((incremental_revenue/revenue_before) * 100, 2) AS "incremental_revenue%"
FROM cte2
ORDER BY "incremental_revenue%" DESC ;