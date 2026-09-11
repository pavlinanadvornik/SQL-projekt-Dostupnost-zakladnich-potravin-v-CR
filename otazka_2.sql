-- Výzkumná otázka č. 2
-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední 
-- srovnatelné období v dostupných datech cen a mezd?


WITH cte_years AS (
	SELECT
		MIN(year) AS first_year,
		MAX(year) AS last_year
	FROM t_pavlina_nadvornikova_project_SQL_primary_final
),
cte_prices AS (
	SELECT
		year,
		food_category,
		average_price
	FROM t_pavlina_nadvornikova_project_SQL_primary_final
	WHERE food_category IN (
		'Mléko polotučné pasterované',
		'Chléb konzumní kmínový'
	)
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
)
SELECT DISTINCT 
	p.year,
	ROUND(w.average_wage::numeric, 2) AS average_wage,
	p.food_category,
	ROUND(p.average_price::numeric, 2) AS average_price,
	ROUND(
		(w.average_wage / p.average_price)::numeric,
		2
	) AS amount_purchasable
FROM cte_prices AS p
JOIN cte_wages AS w
	ON p.year = w.year
WHERE p.year = (SELECT first_year FROM cte_years)
	OR p.year = (SELECT last_year FROM cte_years)
ORDER BY
	p.food_category,
	p.year;

-- Odpověď na otázku č. 2:
-- Z dat vyplývá, že mzda vzrostla výrazněji než cena 2 vybraných potravin.
-- Důsledkem je, že za průměrnou mzdu bylo v roce 2018 možné koupit více chleba i mléka než v roce 2006.
-- Ve výstupních datech jde vidět, kolik chleba a mléka bylo možné koupit koupit za danou mzdu v prvním (2006) a posledním (2018) sledovaném roce.

