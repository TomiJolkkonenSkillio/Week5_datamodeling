-- Star Schema
-- Dimension tables

CREATE TABLE DimCalendar (
    Date DATE PRIMARY KEY,
    Year INT GENERATED ALWAYS AS (YEAR(Date)) STORED,
    Month INT GENERATED ALWAYS AS (MONTH(Date)) STORED,
    Day INT GENERATED ALWAYS AS (DAY(Date)) STORED,
    Weekday INT GENERATED ALWAYS AS (WEEKDAY(Date) + 1) STORED, -- 1=Monday, 7=Sunday
    Quarter INT GENERATED ALWAYS AS (QUARTER(Date)) STORED,
    YearMonth VARCHAR(7) GENERATED ALWAYS AS (DATE_FORMAT(Date, '%Y-%m')) STORED
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
    CONSTRAINT fk_DimCalendar FOREIGN KEY (LoanDate) REFERENCES DimCalendar(Date),
    CONSTRAINT fk_DimCustomers FOREIGN KEY (CustomerID) REFERENCES DimCustomers(CustomerID),
);



-- populate data

-- DimCalendar
INSERT INTO DimCalendar (Date) VALUES
    ('2025-01-01'),
    ('2025-01-02'),
    ('2025-01-03'),
    ('2025-01-04'),
    ('2025-01-05');

-- DimCustomers
INSERT INTO DimCustomers (Name, Email, Date_Of_Birth) VALUES
    ('Samu Syväoja', 'samu.syvaoja@example.com', '1990-02-15'),
    ('Linda Ulma', 'linda.ulma@example.com', '1985-06-23'),
    ('Tomi Jolkkonen', 'tomi.jolkkonen@example.com', '2000-11-12'),
    ('Juha Mieto', 'juha.mieto@example.com', '1995-04-09'),
    ('Beyonce Nikkola', 'beyonce.nikkola@example.com', '1988-09-17');

-- DimBooks
INSERT INTO DimBooks (Title, Author, Genre) VALUES
    ('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction'),
    ('1984', 'George Orwell', 'Dystopian'),
    ('To Kill a Mockingbird', 'Harper Lee', 'Classic'),
    ('Moby Dick', 'Herman Melville', 'Adventure'),
    ('Pride and Prejudice', 'Jane Austen', 'Romance');

-- DimLibrary
INSERT INTO DimLibraries (City, District) VALUES
    ('Helsinki', 'Pasila'),
    ('Vantaa', 'Tikkurila'),
    ('Espoo', 'Leppävaara'),
    ('Kauniainen', 'Keskusta'),
    ('Helsinki', 'Rikhardinkatu');

-- FactLoans
INSERT INTO FactLoans (BookID, LibraryID, DateID, CustomerID, LoanDate, ReturnDate) VALUES
    (1, 1, 1, 1, '2025-01-01', '2025-01-15'),
    (2, 2, 2, 2, '2025-01-02', '2025-01-16'),
    (3, 3, 3, 3, '2025-01-03', '2025-01-17'),
    (4, 4, 4, 4, '2025-01-04', '2025-01-18'),
    (5, 5, 5, 5, '2025-01-05', '2025-01-19');


-- analysis
-- Task 1: Top-loaned books based on the total loans
SELECT 
    b.Title AS Book_Title, 
    COUNT(f.Loan_ID) AS Total_Loans
FROM 
    FactLoans f
JOIN 
    DimBooks b ON f.Book_ID = b.Book_ID
GROUP BY 
    b.Title
ORDER BY 
    Total_Loans DESC
LIMIT 10;

-- Task 2: Current loan amounts of all books
SELECT 
    b.Title AS Book_Title, 
    COUNT(f.Loan_ID) AS Current_Loans
FROM 
    DimBooks b
LEFT JOIN 
    FactLoans f ON b.Book_ID = f.Book_ID AND f.ReturnDate IS NULL
GROUP BY 
    b.Title
ORDER BY 
    Book_Title;

-- Task 3: Customers who have made the most loans
SELECT 
    c.Name AS Customer_Name, 
    COUNT(f.Loan_ID) AS Total_Loans
FROM 
    FactLoans f
JOIN 
    DimCustomers c ON f.Customer_ID = c.Customer_ID
GROUP BY 
    c.Name
ORDER BY 
    Total_Loans DESC
LIMIT 10;
