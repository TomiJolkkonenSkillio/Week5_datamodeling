CREATE TABLE customers (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    City VARCHAR(50),
	Country	VARCHAR(50),		
    CustomerSegment VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    ProductCategory VARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
	Inventory INT NOT NULL		
);

CREATE TABLE orders (
    OrderID SERIAL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    OrderValue DECIMAL(10,2) NOT NULL,
    CustomerID INT NOT NULL,
	CONSTRAINT fk_customers FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID) ON DELETE SET NULL
);

CREATE TABLE orderitems (
    OrderItemID SERIAL PRIMARY KEY,
    Quantity INT NOT NULL,
    OrderID INT NOT NULL,
    ProductID INT,
	CONSTRAINT fk_orders FOREIGN KEY (OrderID) REFERENCES orders(OrderID) ON DELETE CASCADE,
	CONSTRAINT fk_products FOREIGN KEY (ProductID) REFERENCES products(ProductID) ON DELETE SET NULL
);

CREATE TABLE reviews (
    ReviewID SERIAL PRIMARY KEY,
    ReviewDate DATE NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5) NOT NULL,
    Comment VARCHAR(255),
	CustomerID INT,
	ProductID INT,
	CONSTRAINT fk_customers FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID) ON DELETE SET NULL,
	CONSTRAINT fk_products FOREIGN KEY (ProductID) REFERENCES products(ProductID) ON DELETE SET NULL
);