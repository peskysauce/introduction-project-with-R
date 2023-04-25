-- Overview of the tables
SELECT 
    *
FROM
    dbo.energyCons;

SELECT 
    *
FROM
    dbo.population;

SELECT 
    *
FROM dbo.temperatures;

-- Dropping all rows for energy consumption table except India and then renaming columns
DELETE FROM
    dbo.energyCons
WHERE
    Entity != 'India';

EXEC 
    SP_RENAME 'energyCons.Primary_energy_consumption_TWh', 'energy_cons';
EXEC 
    SP_RENAME 'populationNew.Year', 'year';

SELECT 
    *
FROM
    dbo.energyCons;


-- Dropping all column for temperature table except YEAR and ANNUAL, and then renaming columns
ALTER TABLE
    dbo.temperatures
DROP COLUMN
    JAN,
    FEB,
    MAR,
    APR,
    MAY,
    JUN,
    JUL,
    AUG,
    SEP,
    OCT,
    NOV,
    DEC,
    JAN_FEB,
    MAR_MAY,
    JUN_SEP,
    OCT_DEC;

EXEC 
    SP_RENAME 'temperatures.ANNUAL', 'temp';
EXEC 
    SP_RENAME 'temperatures.YEAR', 'year';
    
SELECT 
    *
FROM dbo.temperatures;

-- Selecting Country_Name and India column into another table, and then renaming columns
SELECT
    Country_Name,
    India
INTO
    populationFiltered
FROM
    population;

EXEC SP_RENAME 'populationFiltered.Country_Name', 'year';
EXEC SP_RENAME 'populationFiltered.India', 'population';

SELECT 
    *
FROM
    dbo.populationFiltered;


-- Calculate index and change for energy table. Then insert all the columns to a new table.
DROP TABLE IF EXISTS energyConsNew;

SELECT 
    year,
    energy_cons,
    (energy_cons / 3728.5144) * 100 AS energy_cons_index,
    (energy_cons - LAG (CAST(energy_cons AS FLOAT)) OVER (ORDER BY year ASC)) / LAG (energy_cons) OVER (ORDER BY year ASC) AS energy_cons_change
INTO
    energyConsNew
FROM 
    energyCons;

SELECT 
    * 
FROM 
    energyConsNew;


-- Calculate index and change for population table. Then insert all the columns to a new table.
DROP TABLE IF EXISTS populationNew;

SELECT 
    year,
    population,
    (cast (population / 1059633675.00 AS FLOAT) * 100) AS population_index,
    (population - LAG (CAST(population AS FLOAT)) OVER (ORDER BY year ASC)) / LAG (population) OVER (ORDER BY year ASC) AS population_change
INTO
    populationNew
FROM 
    populationFiltered;

SELECT 
    * 
FROM 
    populationNew;


-- Calculate change for temperature table. Then insert all the columns to a new table.
DROP TABLE IF EXISTS temperaturesNew;

SELECT 
    year,
    temp,
    (temp - LAG (temp) OVER (ORDER BY year ASC)) / LAG (temp) OVER (ORDER BY year ASC) AS temp_change
INTO
    temperaturesNew
FROM 
    temperatures;

SELECT 
    * 
FROM 
    temperaturesNew;


-- Join the three tables together for further analysis with plot in Tableau
DROP TABLE IF EXISTS jointTable;

SELECT 
    pop.year, 
    pop.population,
    pop.population_index,
    pop.population_change,
    ener.energy_cons,
    ener.energy_cons_index,
    ener.energy_cons_change,
    temp.temp,
    temp.temp_change
INTO 
    jointTable
FROM 
    populationNew AS pop
INNER JOIN 
    energyConsNew AS ener
    ON pop.year = ener.year
INNER JOIN 
    temperaturesNew AS temp
    ON pop.year = temp.year;

SELECT
    *
FROM 
    jointTable;