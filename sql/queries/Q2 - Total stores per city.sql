SELECT
	city,
	COUNT(DISTINCT store_id) AS total_stores
FROM dim_stores
GROUP BY city
ORDER BY total_stores DESC ;





