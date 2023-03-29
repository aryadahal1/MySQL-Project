
-- 1) the most populated city in each country.SELECT * FROM city
SELECT * FROM city
WHERE (countrycode,population) IN 
(SELECT countrycode, max(population)
FROM city
GROUP BY countrycode);

--  2) the second most populated city in each country.
SELECT * FROM city
WHERE (countrycode, population) IN (SELECT c.countrycode, max(c.population)
FROM city c INNER JOIN Topcity T  ON c.countrycode = T.countrycode
WHERE c.population < T.maxpop
GROUP BY C.countrycode);

-- Creating a view as TOPCITY
CREATE VIEW TopCity AS
(SELECT countrycode, max(population) AS maxpop
FROM city
GROUP BY countrycode);

--  3) the most populated city in each continent.
SELECT DISTINCT country.Continent, city.Name,  MAX(city.Population) AS Population
FROM city
JOIN country on city.CountryCode = country.Code 
GROUP BY  city.Name, country.Continent;


--  4) the most populated country in each continent.
SELECT DISTINCT Continent, Name, MAX(Population ) FROM country 
GROUP BY Name, Continent;


--  5) the most populated continent.
SELECT Continent, SUM(Population) AS TotalPopulation
FROM country
GROUP BY Continent
ORDER BY TotalPopulation DESC LIMIT 1;

--  6) the number of people speaking each language.
SELECT Language, SUM(country.Population * CL.Percentage / 100) AS sum
FROM country
INNER JOIN countrylanguage AS CL ON CL.countryCode = country.Code
GROUP BY CL.Language;

--  7) the most spoken language in each continent.
SELECT Language, Continent, MAX(speakers) FROM (
    SELECT Language, Continent, SUM(Population * Percentage / 100) AS speakers FROM country
        INNER JOIN countrylanguage AS l ON l.CountryCode = country.Code
        GROUP BY Language, Continent
        ORDER BY speakers DESC
) AS t
GROUP BY Continent, Language;

--  8) number of languages that they are official language of at least one country.
SELECT language, COUNT(*) as `count`
FROM countrylanguage
WHERE IsOfficial = 'T'
GROUP BY language;

--  9)  the most spoken official language based on each continent. (the language that has the highest number of people talking as their mother tongue)
SELECT Language, Continent, MAX(speakers)   FROM (
    SELECT Language, Continent, SUM(Population * Percentage / 100) AS speakers FROM country
        INNER JOIN countrylanguage
        ON countrylanguage.CountryCode = country.Code
        WHERE IsOfficial = 'T'
        GROUP BY Language, Continent
        ORDER BY  speakers DESC
) AS O
GROUP BY Continent, Language;

--  10) the country with the most (number of) unofficial languages based on each continent. (no matter how many people talking that language)
SELECT Continent, U.Name, MAX(U.count) FROM (
    SELECT CountryCode, country.Name, country.Continent, count(*) AS 'count' FROM countrylanguage
    INNER JOIN country ON country.Code = countrylanguage.countryCode
    WHERE IsOfficial = 'F' GROUP BY CountryCode ORDER BY count DESC
) 
AS U GROUP BY Continent, U.Name;

-- 11)  the countries that their capital is not the most populated city in the country.

SELECT country.Name, country.capital, country.population, MAX(city.population) AS max_population, city.Name
FROM country 
JOIN city  ON country.Code = city.countrycode
WHERE country.population < MAX(city.population)
GROUP BY country.Name;

--  12) the countries with population smaller than Russia but bigger than Denmark.
SELECT country.Name FROM country
JOIN country AS russia ON russia.Code = "RUS"
JOIN country AS denmark ON denmark.code = "DNK"
WHERE country.population < russia.population AND country.population > denmark.population;