# SQL projekt – Dostupnost základních potravin v ČR

## Cíl projektu

Cílem projektu je analyzovat vývoj průměrných mezd a cen vybraných potravin v České republice a posoudit, jak se jejich vývoj měnil v čase.

## Výzkumné otázky

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik litrů mléka a kilogramů chleba je možné koupit za průměrnou mzdu na začátku a na konci sledovaného období?
3. Která kategorie potravin zdražuje nejpomaleji?
4. Existuje rok, ve kterém byl meziroční růst cen potravin výrazně vyšší než růst mezd?
5. Má výše HDP vliv na změny mezd a cen potravin?

## Zdrojová data

- czechia_payroll
- czechia_payroll_calculation
- czechia_payroll_industry_branch
- czechia_payroll_unit
- czechia_payroll_value_type
- czechia_price
- czechia_price_category
- czechia_region
- czechia_district
- countries
- economies

## Výstupní tabulky

### Primary table
t_pavlina_nadvornikova_project_SQL_primary_final

Tabulka obsahuje společná data o průměrných mzdách a cenách potravin v České republice.

Obsahuje:
- rok,
- odvětví,
- název odvětví,
- průměrnou mzdu,
- kategorii potraviny,
- průměrnou cenu potraviny.

Průměrná mzda byla vypočtena jako průměr hodnot za jednotlivá odvětví a jednotlivé roky. U cen potravin byla vypočtena průměrná cena za jednotlivé kategorie a roky. Pro společné srovnání mezd a cen bylo použito období 2006–2018.

### Secondary table
t_pavlina_nadvornikova_project_SQL_secondary_final

Tabulka obsahuje doplňková ekonomická data evropských zemí z tabulek economies a countries. Pro výzkumnou otázku č. 5 byla použita data České republiky o HDP v jednotlivých letech.

## Výsledky výzkumných otázek

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Mzdy z dlouhodobého pohledu v období 2006–2018 rostly ve všech sledovaných odvětvích, ale ne každý rok.
Meziroční poklesy mezd se objevily pouze v některých odvětvích. Nejvíce poklesů bylo zaznamenáno v odvětví Těžba a dobývání, kde došlo ke čtyřem meziročním poklesům.

Naopak v odvětvích Doprava a skladování, Ostatní činnosti, Zdravotní a sociální péče a Zpracovatelský průmysl nebyl v analyzovaném období zaznamenán žádný meziroční pokles.

Nejvýraznější jednotlivý pokles byl zaznamenán v odvětví Peněžnictví a pojišťovnictví v roce 2013, kdy mzda meziročně klesla o 8,91 %.

### 2. Kolik litrů mléka a kilogramů chleba je možné koupit za průměrnou mzdu?

První společné srovnatelné období bylo v roce 2006 a poslední v roce 2018. V roce 2006 byla vypočtená průměrná mzda 20 753,78 Kč.

Za tuto mzdu bylo možné koupit přibližně:
- 1 287 kg chleba,
- 1 437 litrů mléka.

V roce 2018 byla vypočtená průměrná mzda 32 355,86 Kč.
Za tuto mzdu bylo možné koupit přibližně:
- 1 342 kg chleba,
- 1 642 litrů mléka.

Z výsledků vyplývá, že mezi lety 2006 a 2018 vzrostlo množství chleba i mléka, které bylo možné za průměrnou mzdu koupit.

### 3. Která kategorie potravin zdražuje nejpomaleji?

Nejnižší průměrnou meziroční změnu ceny měl cukr krystalový, u kterého dosáhla průměrná meziroční změna hodnoty -1,92 %. Záporná hodnota znamená, že cena cukru v průměru meziročně klesala. Druhou nejnižší hodnotu měla rajská jablka červená kulatá (-0,74 %).

Pokud bychom sledovali pouze potraviny s kladným průměrným meziročním růstem ceny, nejpomaleji zdražovaly banány žluté s hodnotou 0,81 %.

### 4. Existuje rok, ve kterém byl meziroční růst cen potravin výrazně vyšší než růst mezd?

Ne. V žádném sledovaném roce nebyl rozdíl mezi růstem cen potravin a růstem mezd vyšší než 10 procentních bodů. 

Největší rozdíl byl zaznamenán v roce 2013.
V tomto roce:
- mzdy meziročně klesly o 1,56 %,
- ceny potravin vzrostly o 5,10 %,
- rozdíl činil 6,65 procentního bodu.
Požadovaná hranice 10 procentních bodů tedy nebyla překročena.

### 5. Má výše HDP vliv na změny mezd a cen potravin?

Z porovnání meziročních změn HDP, mezd a cen potravin nelze potvrdit jednoznačný vztah, že výraznější růst HDP vždy vede k výraznějšímu růstu mezd nebo cen potravin.

U mezd je patrná určitá souvislost. V některých letech s výraznějším růstem HDP následoval také vyšší růst mezd ve stejném nebo následujícím roce. Tento vztah však není pravidelný.

U cen potravin je souvislost méně výrazná. Například v roce 2015 vzrostlo HDP o 5,39 %, ale ceny potravin ve stejném roce klesly o 0,55 % a v následujícím roce o 1,19 %. Naopak v roce 2017 vzrostlo HDP o 5,17 % a ceny potravin ve stejném roce vzrostly o 9,63 %.
