-- Star Schema
-- Dimension tables

CREATE TABLE DimCalendar (
    Date DATE PRIMARY KEY,
    Year INT NOT NULL, 
    Month INT NOT NULL,
    Day INT NOT NULL,
    Weekday INT NOT NULL, -- 1=Monday, 7=Sunday
    Quarter INT NOT NULL,
    YearMonth TEXT NOT NULL
);


CREATE TABLE DimCustomers (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100),
    DateOfBirth DATE
);

CREATE TABLE DimBooks (
    BookID SERIAL PRIMARY KEY,
    Title VARCHAR(50),
    Author VARCHAR(50),
    PublishDate DATE,
    Genre VARCHAR(50)
);

CREATE TABLE DimLibraries (
    LibraryID SERIAL PRIMARY KEY,
    City VARCHAR(50),
    District VARCHAR(50)
);

-- Fact Table

CREATE TABLE FactLoans (
    LoanID SERIAL PRIMARY KEY,
    BookID INT,
    LibraryID INT,
    CustomerID INT,
    LoanDate DATE,
    ReturnDate DATE,
    CONSTRAINT fk_DimBooks FOREIGN KEY (BookID) REFERENCES DimBooks(BookID),
    CONSTRAINT fk_DimLibraries FOREIGN KEY (LibraryID) REFERENCES DimLibraries(LibraryID),
    CONSTRAINT fk_DimCalendar1 FOREIGN KEY (LoanDate) REFERENCES DimCalendar(Date),
    CONSTRAINT fk_DimCalendar2 FOREIGN KEY (ReturnDate) REFERENCES DimCalendar(Date),
    CONSTRAINT fk_DimCustomers FOREIGN KEY (CustomerID) REFERENCES DimCustomers(CustomerID)
);



-- populate data

-- DimCalendar
WITH RECURSIVE DateSeries AS (
    SELECT '2023-01-01'::DATE AS Date  -- Start date (adjust as needed)
    UNION ALL
    SELECT (Date + INTERVAL '1 day')::DATE  -- Cast back to DATE
    FROM DateSeries
    WHERE Date < '2025-12-31'  -- End date
)
INSERT INTO DimCalendar (Date, Year, Month, Day, Weekday, Quarter, YearMonth)
SELECT 
    Date,
    EXTRACT(YEAR FROM Date),
    EXTRACT(MONTH FROM Date),
    EXTRACT(DAY FROM Date),
    EXTRACT(ISODOW FROM Date),  -- 1=Monday, 7=Sunday
    EXTRACT(QUARTER FROM Date),
    TO_CHAR(Date, 'YYYY-MM')
FROM DateSeries;




-- DimCustomers
INSERT INTO DimCustomers (Name, Email, DateOfBirth) VALUES
    ('Samu Syväoja', 'samu.syvaoja@example.com', '1990-02-15'),
    ('Linda Ulma', 'linda.ulma@example.com', '1985-06-23'),
    ('Tomi Jolkkonen', 'tomi.jolkkonen@example.com', '2000-11-12'),
    ('Juha Mieto', 'juha.mieto@example.com', '1995-04-09'),
    ('Beyonce Nikkola', 'beyonce.nikkola@example.com', '1988-09-17');

-- More customers
INSERT INTO DimCustomers (Name, Email, DateOfBirth) VALUES
    ('Aino Laine', 'aino.laine@example.com', '1987-05-10'),
    ('Hannu Kallio', 'hannu.kallio@example.com', '1981-08-21'),
    ('Katriina Palmu', 'katriina.palmu@example.com', '1999-09-03'),
    ('Mikko Rantala', 'mikko.rantala@example.com', '1994-01-25'),
    ('Laura Mikkola', 'laura.mikkola@example.com', '1983-12-14'),
    ('Veikko Salo', 'veikko.salo@example.com', '1991-11-17'),
    ('Anniina Järvinen', 'anniina.jarvinen@example.com', '1997-06-30'),
    ('Risto Hämäläinen', 'risto.hamalainen@example.com', '1990-03-05'),
    ('Elina Nieminen', 'elina.nieminen@example.com', '1986-04-22'),
    ('Jari Peltonen', 'jari.peltonen@example.com', '1995-10-13');


-- DimBooks
INSERT INTO DimBooks (Title, Author, Genre) VALUES
    ('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction'),
    ('1984', 'George Orwell', 'Dystopian'),
    ('To Kill a Mockingbird', 'Harper Lee', 'Classic'),
    ('Moby Dick', 'Herman Melville', 'Adventure'),
    ('Pride and Prejudice', 'Jane Austen', 'Romance');

-- More books
INSERT INTO DimBooks (Title, Author, Genre) VALUES
    ('The Odyssey', 'Homer', 'Classic'),
    ('The Divine Comedy', 'Dante Alighieri', 'Epic Poetry'),
    ('Dracula', 'Bram Stoker', 'Horror'),
    ('Frankenstein', 'Mary Shelley', 'Gothic Fiction'),
    ('The Brothers Karamazov', 'Fyodor Dostoevsky', 'Philosophical Fiction'),
    ('The Great Alone', 'Kristin Hannah', 'Historical Fiction'),
    ('The Fault in Our Stars', 'John Green', 'Romance'),
    ('The Hunger Games', 'Suzanne Collins', 'Dystopian'),
    ('Little Women', 'Louisa May Alcott', 'Classic'),
    ('Catch-22', 'Joseph Heller', 'Satire');


-- DimLibrary
INSERT INTO DimLibraries (City, District) VALUES
    ('Helsinki', 'Pasila'),
    ('Vantaa', 'Tikkurila'),
    ('Espoo', 'Leppävaara'),
    ('Kauniainen', 'Keskusta'),
    ('Helsinki', 'Rikhardinkatu');

-- FactLoans
INSERT INTO FactLoans (BookID, LibraryID, CustomerID, LoanDate, ReturnDate) VALUES
    (1, 1, 1, '2025-01-01', '2025-01-15'),
    (2, 2, 2, '2025-01-02', '2025-01-16'),
    (3, 3, 3, '2025-01-03', '2025-01-17'),
    (4, 4, 4, '2025-01-04', '2025-01-18'),
    (5, 5, 5, '2025-01-05', '2025-01-19');

-- More loans
INSERT INTO FactLoans (BookID, LibraryID, CustomerID, LoanDate, ReturnDate) VALUES
    (1, 1, 6, '2025-01-16', '2025-01-30'),
    (2, 2, 7, '2025-01-17', '2025-01-31'),
    (3, 3, 8, '2025-01-18', '2025-02-01'),
    (4, 4, 9, '2025-01-19', '2025-02-02'),
    (5, 5, 10, '2025-01-20', '2025-02-03'),
    (6, 1, 1, '2025-01-21', '2025-02-04'),
    (7, 2, 2, '2025-01-22', '2025-02-05'),
    (8, 3, 3, '2025-01-23', '2025-02-06'),
    (9, 4, 4, '2025-01-24', '2025-02-07'),
    (10, 5, 5, '2025-01-25', '2025-02-08'),
    (11, 1, 11, '2025-01-26', '2025-02-09'),
    (12, 2, 12, '2025-01-27', '2025-02-10'),
    (13, 3, 13, '2025-01-28', '2025-02-11'),
    (14, 4, 14, '2025-01-29', '2025-02-12'),
    (15, 5, 15, '2025-01-30', '2025-02-13'),
    (6, 1, 3, '2025-01-31', '2025-02-14'),
    (7, 2, 8, '2025-02-01', '2025-02-15'),
    (8, 3, 11, '2025-02-02', '2025-02-16'),
    (9, 4, 14, '2025-02-03', '2025-02-17'),
    (10, 5, 5, '2025-02-04', '2025-02-18'),
    (1, 1, 7, '2025-02-05', '2025-02-19');


-- analysis
-- Task 1: Top-loaned books based on the total loans
SELECT 
    b.Title AS BookTitle, 
    COUNT(f.LoanID) AS TotalLoans
FROM 
    FactLoans f
JOIN 
    DimBooks b ON f.BookID = b.BookID
GROUP BY 
    b.Title
ORDER BY 
    TotalLoans DESC
LIMIT 10;

-- Task 2: Current loan amounts of all books
SELECT 
    b.Title AS BookTitle, 
    COUNT(f.LoanID) AS CurrentLoans
FROM 
    DimBooks b
LEFT JOIN 
    FactLoans f ON b.BookID = f.BookID AND f.ReturnDate IS NULL
GROUP BY 
    b.Title
ORDER BY 
    BookTitle;

-- Task 3: Customers who have made the most loans
SELECT 
    c.Name AS CustomerName, 
    COUNT(f.LoanID) AS TotalLoans
FROM 
    FactLoans f
JOIN 
    DimCustomers c ON f.CustomerID = c.CustomerID
GROUP BY 
    c.Name
ORDER BY 
    TotalLoans DESC
LIMIT 10;