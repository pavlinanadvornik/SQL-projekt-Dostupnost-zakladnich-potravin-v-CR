-- Výzkumná otázka č. 5
-- Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin 
-- či mzdách ve stejném nebo následujícím roce výraznějším růstem?


WITH cte_gdp AS (
	SELECT
		year,
		gdp
	FROM t_pavlina_nadvornikova_project_SQL_secondary_final
	WHERE country = 'Czech Republic'
),
cte_gdp_lag AS (
	SELECT
		year,
		gdp,
		LAG(gdp) OVER (ORDER BY year) AS gdp_previous_year
	FROM cte_gdp
)
SELECT
	year,
	gdp,
	gdp_previous_year,
	ROUND(
		(
			(gdp - gdp_previous_year)
			/ gdp_previous_year
		)::numeric * 100,
		2
	) AS gdp_growth_percent
FROM cte_gdp_lag
WHERE gdp_previous_year IS NOT NULL
ORDER BY year;


-- Porovnání HDP, mezd a cen potravin:
WITH cte_gdp AS (
	SELECT
		year,
		gdp
	FROM t_pavlina_nadvornikova_project_SQL_secondary_final
	WHERE country = 'Czech Republic'
),
cte_gdp_lag AS (
	SELECT
		year,
		gdp,
		LAG(gdp) OVER (ORDER BY year) AS gdp_previous_year
	FROM cte_gdp
),
cte_wages AS (
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
),
cte_growth AS (
	SELECT
		g.year,
		((g.gdp - g.gdp_previous_year) / g.gdp_previous_year) * 100 AS gdp_growth_percent,
		((w.average_wage - w.average_wage_previous_year) / w.average_wage_previous_year) * 100 AS wage_growth_percent,
		LEAD(
			((w.average_wage - w.average_wage_previous_year) / w.average_wage_previous_year) * 100
		) OVER (ORDER BY g.year) AS wage_growth_next_year,
		((p.average_food_price - p.average_food_price_previous_year) / p.average_food_price_previous_year) * 100 AS food_price_growth_percent,
		LEAD(
			((p.average_food_price - p.average_food_price_previous_year) / p.average_food_price_previous_year) * 100
		) OVER (ORDER BY g.year) AS food_price_growth_next_year
	FROM cte_gdp_lag AS g
	JOIN cte_wages_lag AS w
		ON g.year = w.year
	JOIN cte_prices_lag AS p
		ON g.year = p.year
	WHERE g.gdp_previous_year IS NOT NULL
		AND w.average_wage_previous_year IS NOT NULL
		AND p.average_food_price_previous_year IS NOT NULL
)
SELECT
	year,
	ROUND(gdp_growth_percent::numeric, 2) AS gdp_growth_percent,
	ROUND(wage_growth_percent::numeric, 2) AS wage_growth_same_year_percent,
	ROUND(wage_growth_next_year::numeric, 2) AS wage_growth_next_year_percent,
	ROUND(food_price_growth_percent::numeric, 2) AS food_price_growth_same_year_percent,
	ROUND(food_price_growth_next_year::numeric, 2) AS food_price_growth_next_year_percent
FROM cte_growth
ORDER BY year;

-- Výsledkem je přehled, který ukazuje, zda se výraznější růst HDP projevil ve změně mezd nebo cen potravin ve stejném nebo následujícím roce
-- Výsledná data obsahují rok, růst HDP v daném roce, růst mezd ve stejném roce, růst mezd v následujícím roce, růst cen potravin ve stejném roce, růst cen v nýásledujícím roce
-- V r. 2007 je vidět výrazný růst mezd i cen. V r. 2017 byl výraznější růst mezd i cen potravin ve stejném roce, ale růst cen se následující rok výrazně zpomalil.
-- Z dat nelze vyvodit, že když klesne HDP, klesnou i mzdy. Např. v r. 2009 jde vidět, že mzdy vzrostly o 3,16 % a ceny potravin klesly o 6,41 %. V následujícím mzdy + 1,95 %, ceny potravin + 1,94 %.
-- Odpověď na otázku:
-- Z dat nelze potvrdit jednoznačný vztah, že výraznější růst HDP vždy vede k výraznějšímu růstu mezd nebo cen potravin.
-- Z výsledků vyplývá souvislost mezi růstem HDP a růstem mezd (např. při sledování HDP r. 2007, 2015, 2017 a mezd v následujících letech).
-- Vyšší růst HDP lze spojit s vyšším růstem mezd, ale neplatí to ve všech případech (např. při sledování HDP r. 2015, 2016, 2017 a cen potravin).
 



