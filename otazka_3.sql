-- Výzkumná otázka č. 3
-- Která kategorie potravin zdražuje nejpomaleji 
-- (je u ní nejnižší percentuální meziroční nárůst)? 



WITH cte_prices AS (
	SELECT DISTINCT
		year,
		food_category,
		average_price
	FROM t_pavlina_nadvornikova_project_SQL_primary_final
),
cte_prices_lag AS (
	SELECT
		year,
		food_category,
		average_price,
		LAG(average_price) OVER (
			PARTITION BY food_category
			ORDER BY year
		) AS average_price_previous_year
	FROM cte_prices
),
cte_price_growth AS (
	SELECT
		year,
		food_category,
		average_price,
		average_price_previous_year,
		(
			(average_price - average_price_previous_year)
			/ average_price_previous_year
		) * 100 AS price_growth_percent
	FROM cte_prices_lag
	WHERE average_price_previous_year IS NOT NULL
)
SELECT
	food_category,
	ROUND(AVG(price_growth_percent)::numeric, 2)
		AS average_yearly_growth_percent
FROM cte_price_growth
GROUP BY food_category
ORDER BY average_yearly_growth_percent;

-- Výstupní data: výstupem jsou jednotlivé kategorie potravin a jejich průměrný meziroční procentuální růst ceny
-- První rok není do výpočtu zahrnutý, protože pro něj není k dispozici předchozí rok, se kterým by bylo možné cenu porovnat.
-- Výsledná data jsou seřazená od nejnižšího průměrného meziročního růstu ceny.
-- Výsledek: Nejnižší průměrnou meziroční změnu ceny měl cukr krystalový (který zlevňoval). Za nejpomaleji zdražující kategorii (s kladnou hodnotou) se dají považovat banány žluté.
