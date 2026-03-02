SELECT
	DISTINCT dp.product_code,
	dp.product_name,
	dp.category,
	fe.base_price
FROM dim_products dp
INNER JOIN fact_events fe
	ON dp.product_code = fe.product_code
WHERE fe.base_price > 500 
	AND fe.promo_type = 'BOGOF' ;




