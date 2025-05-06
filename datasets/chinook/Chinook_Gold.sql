SELECT ArtistId FROM Album GROUP BY ArtistId HAVING COUNT(AlbumId) > 10;	chinook
SELECT FirstName, LastName FROM Customer WHERE Country = 'Brazil';	chinook
SELECT Name FROM Track WHERE Milliseconds > 300000;	chinook
SELECT FirstName, LastName FROM Employee WHERE Title = 'Sales Manager';	chinook
SELECT Email FROM Customer WHERE City = 'Paris';	chinook
SELECT CustomerId, SUM(Total) FROM Invoice GROUP BY CustomerId;	chinook
SELECT Name FROM Track ORDER BY UnitPrice DESC LIMIT 5;	chinook
SELECT Name FROM Track WHERE GenreId = (SELECT GenreId FROM Genre WHERE Name = 'Rock');	chinook
SELECT BillingCountry, COUNT(*) FROM Invoice GROUP BY BillingCountry;	chinook
SELECT Name FROM Artist WHERE ArtistId = (SELECT ArtistId FROM Album WHERE Title = 'Californication');	chinook
SELECT CustomerId FROM Customer WHERE CustomerId NOT IN (SELECT CustomerId FROM Invoice);	chinook
SELECT COUNT(*) FROM Genre;	chinook
SELECT AVG(Total) FROM Invoice;	chinook
SELECT FirstName, LastName FROM Employee WHERE ReportsTo = (SELECT EmployeeId FROM Employee WHERE FirstName = 'Steve' AND LastName = 'Johnson');	chinook
SELECT Name FROM Track WHERE Composer = 'AC/DC';	chinook
SELECT COUNT(*) FROM Playlist;	chinook
SELECT CustomerId FROM Customer WHERE Country = 'USA' AND CustomerId IN (SELECT CustomerId FROM Invoice GROUP BY CustomerId HAVING SUM(Total) > 30);	chinook
SELECT t.Name, a.Title FROM Track t JOIN Album a ON t.AlbumId = a.AlbumId;	chinook
SELECT FirstName, LastName FROM Employee ORDER BY HireDate DESC LIMIT 1;	chinook
SELECT InvoiceId, Total FROM Invoice WHERE Total > (SELECT AVG(Total) FROM Invoice);	chinook
SELECT Name FROM Track WHERE Name LIKE '%Love%';	chinook
SELECT DISTINCT c.CustomerId FROM Customer c JOIN Invoice i ON c.CustomerId = i.CustomerId JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId JOIN Track t ON il.TrackId = t.TrackId WHERE t.Composer = 'Queen';	chinook
SELECT Name FROM MediaType;	chinook
SELECT City FROM Customer GROUP BY City ORDER BY COUNT(*) DESC LIMIT 1;	chinook
SELECT FirstName, LastName FROM Employee WHERE ReportsTo IS NOT NULL;	chinook
SELECT SUM(Milliseconds)/60000.0 FROM Track;	chinook
SELECT COUNT(*) FROM PlaylistTrack WHERE PlaylistId = (SELECT PlaylistId FROM Playlist WHERE Name = 'Rock');	chinook
SELECT CustomerId FROM Invoice GROUP BY CustomerId HAVING COUNT(*) > 2;	chinook
SELECT AlbumId FROM Track GROUP BY AlbumId HAVING COUNT(*) > 15;	chinook
SELECT FirstName, LastName FROM Customer WHERE City LIKE 'L%';	chinook
