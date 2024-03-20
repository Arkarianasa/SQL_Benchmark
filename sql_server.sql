--------- Unnecessary Distinct ---------
----------------------------------------
-- Using distinct on already unique values
SELECT DISTINCT(MediaTypeId)
FROM MediaType;

-------- Unnecessary Conditions --------
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
WHERE BillingCity IS NULL AND BillingCity IS NULL;

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

---------- Unnecessary Joins -----------
----------------------------------------
-- Using unnecessary JOIN if we only use attributes from one table.
SELECT Invoice.InvoiceId, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
WHERE Invoice.Total < 1;

-- JOINing table on itself that duplicate values.
SELECT *
FROM Genre as g1
JOIN Genre as g2 ON g1.GenreId=g2.GenreId;

-- Creating a Cartesian product that duplicates tuples.
SELECT *
FROM Genre as g1
CROSS JOIN Genre as g2;

SELECT *
FROM Genre
UNION
SELECT *
FROM Genre;

-----    Unnecessary Aggregations ------
----------------------------------------
-- Applying COUNT() to a column that's already unique.
SELECT Count(TrackId), Count(Name), Count(*)
FROM Track;

--------- Unnecessary Grouping ---------
----------------------------------------
-- Using group by on id is unnecessary and redundant because there is always only one row per id.
SELECT ArtistId, COUNT(*)
FROM Artist
GROUP BY ArtistId;