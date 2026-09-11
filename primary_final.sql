-- Primární tabulka slouží jako společný datový podklad 
-- pro analýzu mezd a cen potravin v České republice.

DROP TABLE IF EXISTS t_pavlina_nadvornikova_project_SQL_primary_final;


SELECT *
FROM czechia_price AS cp;

SELECT *
FROM czechia_payroll_industry_branch AS cpib; 

CREATE TABLE t_pavlina_nadvornikova_project_SQL_primary_final AS
WITH payroll AS (
	SELECT
		cpp.payroll_year AS year,
		cpp.industry_branch_code,
		cpib.name AS industry_name,
		AVG(cpp.value) AS average_wage
	FROM data_academy_content.czechia_payroll AS cpp
	JOIN data_academy_content.czechia_payroll_industry_branch AS cpib
		ON cpp.industry_branch_code = cpib.code
	WHERE cpp.value_type_code = 5958
		AND cpp.value IS NOT NULL
	GROUP BY
		cpp.payroll_year,
		cpp.industry_branch_code,
		cpib.name
),
prices AS (
	SELECT
		date_part('year', cp.date_from) AS year,
		cp.category_code,
		cpc.name AS food_category,
		AVG(cp.value) AS average_price
	FROM data_academy_content.czechia_price AS cp
	JOIN data_academy_content.czechia_price_category AS cpc
		ON cp.category_code = cpc.code
	WHERE cp.region_code IS NULL
		AND cp.value IS NOT NULL
	GROUP BY
		date_part('year', cp.date_from),
		cp.category_code,
		cpc.name
)
SELECT
	p.year,
	p.industry_branch_code,
	p.industry_name,
	p.average_wage,
	pr.category_code,
	pr.food_category,
	pr.average_price
FROM payroll AS p
JOIN prices AS pr
	ON p.year = pr.year
WHERE p.year BETWEEN
	(SELECT MIN(year) FROM prices)
	AND
	(SELECT MAX(year) FROM prices);

SELECT *
FROM t_pavlina_nadvornikova_project_SQL_primary_final;

SELECT
	MIN(year) AS first_year,
	MAX(year) AS last_year
FROM t_pavlina_nadvornikova_project_SQL_primary_final;