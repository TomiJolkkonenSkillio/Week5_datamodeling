-- first dimension tables, otherwise it doesn´t work if you try to create fact table without references ready
-- create Date Dimension
CREATE TABLE DimDate (
    Date_key SERIAL PRIMARY KEY,
    Sale_date DATE,
    Year INT,
    Month INT,
    Day_of_week VARCHAR(10),
    Week_of_year INT,
    Quarter INT,
    Is_weekend BOOLEAN
);

-- create Customer Dimension
CREATE TABLE DimCustomer (
    Customer_id SERIAL PRIMARY KEY,
    Customer_name VARCHAR(100),
    Gender VARCHAR(10),
    Customer_birth_date DATE,
    Customer_email VARCHAR(100),
    Customer_city VARCHAR(100),
    Customer_country VARCHAR(100),
    Customer_phone VARCHAR(15)
);

-- create Book Dimension
CREATE TABLE DimBook (
    Book_id SERIAL PRIMARY KEY,
    Book_title VARCHAR(200),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Publisher VARCHAR(100),
    Publication_year INT,
    Language VARCHAR(50)
);

-- create Store Dimension
CREATE TABLE DimStore (
    Store_id SERIAL PRIMARY KEY,
    Store_name VARCHAR(100),
    Store_city VARCHAR(100),
    Store_country VARCHAR(100),
    Store_type VARCHAR(50)
);

-- create Loyalty Program Dimension
CREATE TABLE DimLoyaltyProgram (
    Loyalty_program_id SERIAL PRIMARY KEY,
    Loyalty_program_level VARCHAR(50),
    Enrollment_date DATE,
    Status VARCHAR(20),
    Reward_points_balance INT
);

-- create Discount Dimension (not necessary)
CREATE TABLE DimDiscount (
    Discount_id SERIAL PRIMARY KEY,
    Discount_percentage DECIMAL(5, 2),
    Discount_start_date DATE,
    Discount_end_date DATE,
    Discount_type VARCHAR(50)
);



-- create Fact Table
CREATE TABLE FactBookSales (
    Sale_id SERIAL PRIMARY KEY,
    Date_key INT NOT NULL,  -- This matches the INT type in DimDate
    Customer_id INT NOT NULL,
    Book_id INT NOT NULL,
    Store_id INT NOT NULL,
    Loyalty_program_id INT,
    Payment_type VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10, 2),
    Total_sales_amount DECIMAL(10, 2),
    Discount_amount DECIMAL(10, 2),
    Net_sales_amount DECIMAL(10, 2),
    FOREIGN KEY (Date_key) REFERENCES DimDate(Date_key), 
    FOREIGN KEY (Customer_id) REFERENCES DimCustomer(Customer_id),
    FOREIGN KEY (Book_id) REFERENCES DimBook(Book_id),
    FOREIGN KEY (Store_id) REFERENCES DimStore(Store_id),
    FOREIGN KEY (Loyalty_program_id) REFERENCES DimLoyaltyProgram(Loyalty_program_id)
);
