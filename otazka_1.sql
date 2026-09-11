-- Výzkumná otázka č. 1
-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?



-- Dotaz zobrazuje, kolikrát došlo v jednotlivých odvětvích k poklesu průměrné mzdy.
WITH cte_wages AS (
	SELECT DISTINCT
		year,
		industry_name,
		average_wage
	FROM t_pavlina_nadvornikova_project_SQL_primary_final
),
cte_wages_lag AS (
	SELECT
		year,
		industry_name,
		average_wage,
		LAG(average_wage) OVER (
			PARTITION BY industry_name
			ORDER BY year
		) AS average_wage_previous_year
	FROM cte_wages
)
SELECT
	industry_name,
	COUNT(*) AS number_of_decreases
FROM cte_wages_lag
WHERE average_wage < average_wage_previous_year
GROUP BY industry_name
ORDER BY number_of_decreases DESC;



-- Dotaz zobrazuje rok, název odvětví, průměrnou mzdu, 
-- průměrnou mzdu z loňského roku, procentuální změnu a trend, zda mzda
-- rostla, stagnovala nebo klesala.
WITH cte_wages AS (
	SELECT DISTINCT
		year,
		industry_name,
		average_wage
	FROM t_pavlina_nadvornikova_project_SQL_primary_final
),
cte_wages_lag AS (
	SELECT
		year,
		industry_name,
		average_wage,
		LAG(average_wage) OVER (
			PARTITION BY industry_name
			ORDER BY year
		) AS average_wage_previous_year
	FROM cte_wages
)
SELECT
	year,
	industry_name,
	ROUND(average_wage::numeric, 2) AS average_wage,
	ROUND(average_wage_previous_year::numeric, 2) AS average_wage_previous_year,
	ROUND(
		(
			(average_wage - average_wage_previous_year)
			/ average_wage_previous_year
		)::numeric * 100,
		2
	) AS wage_growth_percent,
	CASE
		WHEN average_wage > average_wage_previous_year THEN 'růst'
		WHEN average_wage = average_wage_previous_year THEN 'stagnace'
		WHEN average_wage < average_wage_previous_year THEN 'pokles'
	END AS trend
FROM cte_wages_lag
ORDER BY
	industry_name,
	year;

-- Odpověď na otázku č. 1:
-- Mzdy v průběhu let rostly ve všech odvětvích, ale ne nepřetržitě. Ve všech odvětvích se alespoň jednou objevil meziroční pokles mzdy. 
-- Nejvíce poklesů bylo v odvětví Těžba a dobývání. U většiny ostatních odvětví se pokles objevil jednou nebo dvakrát.
