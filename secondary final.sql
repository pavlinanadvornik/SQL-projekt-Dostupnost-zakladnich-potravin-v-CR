
DROP TABLE IF EXISTS t_pavlina_nadvornikova_project_SQL_secondary_final;


CREATE TABLE t_pavlina_nadvornikova_project_SQL_secondary_final AS
SELECT
	e.country,
	e.year,
	e.gdp,
	e.population,
	e.gini
FROM data_academy_content.economies AS e
JOIN data_academy_content.countries AS c
	ON e.country = c.country
WHERE c.continent = 'Europe'
	AND e.year BETWEEN 2006 AND 2021
	AND e.gdp IS NOT NULL
	AND e.population IS NOT NULL;