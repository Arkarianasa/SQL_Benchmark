--------- Redundant Attributes ---------
----------------------------------------
-- We already know the attribute country, there is no need to have it in the SELECT.
SELECT FirstName, LastName, Country
FROM Customer
WHERE Country = 'Czech Republic';


--------------- Distinct ---------------
----------------------------------------
-- Using distinct on already unique values.
SELECT DISTINCT(MediaTypeId)
FROM MediaType;

-------------- Conditions --------------
----------------------------------------
-- InvoiceId is unique for each invoice therefore BillingCountry condition is unnecessary and redundant.
SELECT *
FROM Invoice
WHERE InvoiceId = 1 AND BillingCountry = 'USA';

-- Duplicated (redundant) conditions with OR operator.
SELECT *
FROM Customer
WHERE Country = 'USA' OR Country = 'USA';

-- Duplicated (redundant) conditions with AND operator.
SELECT *
FROM Invoice
WHERE BillingCity = 'Oslo' AND BillingCity = 'Oslo';

-- Mutually exclusive conditions.
SELECT *
FROM Album
WHERE Title = 'Fireball' AND Title = 'Outbreak';

-- Mutually exclusive conditions.
SELECT Name
FROM Track
WHERE UnitPrice < 1 AND
      UnitPrice > 1.5;

-- Using unnecessary conditions that were already fulfilled by another condition.
SELECT *
FROM Track
WHERE Milliseconds > 300000 AND
      Milliseconds > 200000;

-- Redundant values in the IN list.
SELECT *
FROM Track
WHERE GenreId IN (1, 1, 2, 3);

-- Conditioning attribute to be from any of its unique values.
SELECT *
FROM InvoiceLine
WHERE TrackId IN (SELECT TrackId FROM Track);

-- Conditioning attribute to be from any of its unique values - all employees are from Canada.
SELECT *
FROM Employee
WHERE Country = 'Canada';

-- Unnecessary condition, comparing name to "anything".
SELECT TrackId, Name
FROM Track
WHERE Name LIKE '%';

-- Using LIKE without wildcards.
SELECT FirstName, LastName
FROM Customer
WHERE Country LIKE 'USA';

--Unnecessary IN/EXISTS condition that could be replaced by simple comparison.
SELECT *
FROM Invoice
WHERE BillingCountry NOT IN
(SELECT BillingCountry
 FROM Invoice
 WHERE BillingCountry = 'Germany');

---------------- Joins -----------------
----------------------------------------
-- Using unnecessary JOIN if we only use attributes from one table.
SELECT Invoice.InvoiceId, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
WHERE Invoice.Total < 1;

-- JOINing table on itself that duplicates output column.
SELECT *
FROM Genre as g1
JOIN Genre as g2 ON g1.GenreId=g2.GenreId;

-- Creating a Cartesian product that duplicates output column and tuples.
SELECT *
FROM Genre as g1
CROSS JOIN Genre as g2;

-- Unnecessary UNION.
SELECT *
FROM Genre
UNION
SELECT *
FROM Genre;

-- Using outer join that can be replaced by inner join. All tuples generated by the outer join are eliminated by the WHERE-condition.
SELECT t.TrackId, t.Name, il.InvoiceLineId
FROM Track t LEFT OUTER JOIN InvoiceLine il ON t.TrackId = il.TrackId
WHERE il.InvoiceLineId IS NOT NULL;

------------- Aggregations -------------
----------------------------------------
-- Applying COUNT() to a column that's already unique.
SELECT Count(TrackId), Count(Name), Count(*)
FROM Track;

-- Unnecessary single distinct input value aggregations that could be replaced by SELECT DISTINCT.
SELECT MAX(UnitPrice)
FROM Track
GROUP BY UnitPrice;

-- Unnecessary DISTINCT in MIN / MAX aggregations.
SELECT MAX(DISTINCT Milliseconds)
FROM Track;

--------------- Grouping ---------------
----------------------------------------
-- Using group by on id is unnecessary and redundant because there is always only one tuple per id.
SELECT ArtistId, COUNT(*)
FROM Artist
GROUP BY ArtistId;

---------------- Having ----------------
----------------------------------------
-- Doing the join condition under HAVING instead of in WHERE is possible, but has awful performance.
-- !! not correct !!
SELECT Invoice.BillingCity, COUNT(*)
FROM Invoice, InvoiceLine
GROUP BY Invoice.BillingCity, Invoice.InvoiceId
HAVING Invoice.InvoiceId = InvoiceLine.InvoiceId;
