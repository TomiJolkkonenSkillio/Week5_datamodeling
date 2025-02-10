CREATE TABLE customers IF NOT EXISTS (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
	country	VARCHAR(50),		
    customer_segment VARCHAR(50) NOT NULL
);

