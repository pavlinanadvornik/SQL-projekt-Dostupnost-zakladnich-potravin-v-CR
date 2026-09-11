-- Výzkumná otázka č. 4
-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- Roky, kdy byl rozdíl větší než 10 procentních bodů:
WITH cte_wages AS (
	SELECT
		year,
		AVG(average_wage) AS average_wage
	FROM (
		SELECT DISTINCT
			year,
			industry_name,
			average_wage
		FROM t_pavlina_nadvornikova_project_SQL_primary_final
	) AS wages
	GROUP BY year
),
cte_wages_lag AS (
	SELECT
		year,
		average_wage,
		LAG(average_wage) OVER (ORDER BY year)
			AS average_wage_previous_year
	FROM cte_wages
),
cte_prices AS (
	SELECT
		year,
		AVG(average_price) AS average_food_price
	FROM (
		SELECT DISTINCT
			year,
			food_category,
			average_price
		FROM t_pavlina_nadvornikova_project_SQL_primary_final
	) AS prices
	GROUP BY year
),
cte_prices_lag AS (
	SELECT
		year,
		average_food_price,
		LAG(average_food_price) OVER (ORDER BY year)
			AS average_food_price_previous_year
	FROM cte_prices
)
SELECT
	w.year,
	ROUND(
		(
			(w.average_wage - w.average_wage_previous_year)
			/ w.average_wage_previous_year
		)::numeric * 100,
		2
	) AS wage_growth_percent,
	ROUND(
		(
			(p.average_food_price - p.average_food_price_previous_year)
			/ p.average_food_price_previous_year
		)::numeric * 100,
		2
	) AS food_price_growth_percent
FROM cte_wages_lag AS w
JOIN cte_prices_lag AS p
	ON w.year = p.year
WHERE w.average_wage_previous_year IS NOT NULL
	AND p.average_food_price_previous_year IS NOT NULL
	AND (
		(
			(p.average_food_price - p.average_food_price_previous_year)
			/ p.average_food_price_previous_year
		)
		-
		(
			(w.average_wage - w.average_wage_previous_year)
			/ w.average_wage_previous_year
		)
	) > 0.10
ORDER BY w.year;


-- Porovnání růstu cen potravin a mezd:
WITH cte_wages AS (
	SELECT
		year,
		AVG(average_wage) AS average_wage
	FROM (
		SELECT DISTINCT
			year,
			industry_name,
			average_wage
		FROM t_pavlina_nadvornikova_project_SQL_primary_final
	) AS wages
	GROUP BY year
),
cte_wages_lag AS (
	SELECT
		year,
		average_wage,
		LAG(average_wage) OVER (
			ORDER BY year
		) AS average_wage_previous_year
	FROM cte_wages
),
cte_prices AS (
	SELECT
		year,
		AVG(average_price) AS average_food_price
	FROM (
		SELECT DISTINCT
			year,
			food_category,
			average_price
		FROM t_pavlina_nadvornikova_project_SQL_primary_final
	) AS prices
	GROUP BY year
),
cte_prices_lag AS (
	SELECT
		year,
		average_food_price,
		LAG(average_food_price) OVER (
			ORDER BY year
		) AS average_food_price_previous_year
	FROM cte_prices
)
SELECT
	w.year,
	ROUND(
		(
			(w.average_wage - w.average_wage_previous_year)
			/ w.average_wage_previous_year
		)::numeric * 100,
		2
	) AS wage_growth_percent,
	ROUND(
		(
			(p.average_food_price - p.average_food_price_previous_year)
			/ p.average_food_price_previous_year
		)::numeric * 100,
		2
	) AS food_price_growth_percent,
	ROUND(
		(
			(
				(p.average_food_price - p.average_food_price_previous_year)
				/ p.average_food_price_previous_year
			)
			-
			(
				(w.average_wage - w.average_wage_previous_year)
				/ w.average_wage_previous_year
			)
		)::numeric * 100,
		2
	) AS difference_percent
FROM cte_wages_lag AS w
JOIN cte_prices_lag AS p
	ON w.year = p.year
WHERE w.average_wage_previous_year IS NOT NULL
	AND p.average_food_price_previous_year IS NOT NULL
ORDER BY w.year;

-- Výstupní data zobrazují rok, růst průměrných mezd, růst průměrných cen potravin a růst cen potravin - růst mezd
-- Nejvyšší rozdíl ve sledovaném období byl r. 2013: 6,65 procentního bodu. Ceny potravin rostly v r. 2013 rychleji než mzdy, 
-- ale rozdíl nepřekročil 10 procentních bodů.
-- Odpověd na otázku č. 4: Ne. V datech není rok, ve kterém by meziroční růst cen potravin převýšil růst mezd o více než 10 procentních bodů.
-- Největší rozdíl byl v r. 2013, kdy ceny potravin vzrostly o 5,10 % a mzdy meziroční klesly o 1,56 %.


