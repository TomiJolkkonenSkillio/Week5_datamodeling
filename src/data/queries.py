import psycopg2
from config import config
from datetime import datetime

# @group work Linda, Samu, Tomi

def database_design():
    con = None
    try:
        con = psycopg2.connect(**config())
        cursor = con.cursor()

        # SQL to create the customers table
        SQL_CREATE_CUSTOMERS_TABLE = '''
        CREATE TABLE IF NOT EXISTS customers (
            customer_id SERIAL PRIMARY KEY,
            name VARCHAR(50) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            city VARCHAR(50),
            country VARCHAR(50),		
            customer_segment VARCHAR(50) NOT NULL
        );
        '''
        cursor.execute(SQL_CREATE_CUSTOMERS_TABLE)

        # SQL to create the products table
        SQL_CREATE_PRODUCTS_TABLE = '''
        CREATE TABLE IF NOT EXISTS products (
            product_id SERIAL PRIMARY KEY,
            product_name VARCHAR(50) NOT NULL,
            product_category VARCHAR(50) NOT NULL,
            unit_price DECIMAL(10,2) NOT NULL,
            inventory INT NOT NULL		
        );
        '''
        cursor.execute(SQL_CREATE_PRODUCTS_TABLE)

        # SQL to create the orders table
        SQL_CREATE_ORDERS_TABLE = '''
        CREATE TABLE IF NOT EXISTS orders (
            OrderID SERIAL PRIMARY KEY,
            OrderDate DATE NOT NULL,
            OrderValue DECIMAL(10,2) NOT NULL,
            CustomerID INT,
            CONSTRAINT fk_customers FOREIGN KEY (CustomerID) REFERENCES customers(customer_id) ON DELETE SET NULL
        );
        '''
        cursor.execute(SQL_CREATE_ORDERS_TABLE)

        # SQL to create the orderitems table
        SQL_CREATE_ORDERITEMS_TABLE = '''
        CREATE TABLE IF NOT EXISTS orderitems (
            OrderItemID SERIAL PRIMARY KEY,
            Quantity INT NOT NULL,
            OrderID INT NOT NULL,
            ProductID INT,
            CONSTRAINT fk_orders FOREIGN KEY (OrderID) REFERENCES orders(OrderID) ON DELETE CASCADE,
            CONSTRAINT fk_products FOREIGN KEY (ProductID) REFERENCES products(product_id) ON DELETE SET NULL
        );
        '''
        cursor.execute(SQL_CREATE_ORDERITEMS_TABLE)

        # SQL to create the reviews table
        SQL_CREATE_REVIEWS_TABLE = '''
        CREATE TABLE IF NOT EXISTS reviews (
            ReviewID SERIAL PRIMARY KEY,
            ReviewDate DATE NOT NULL,
            Rating INT CHECK (Rating BETWEEN 1 AND 5) NOT NULL,
            Comment VARCHAR(255),
            CustomerID INT,
            ProductID INT,
            CONSTRAINT fk_customers FOREIGN KEY (CustomerID) REFERENCES customers(customer_id) ON DELETE SET NULL,
            CONSTRAINT fk_products FOREIGN KEY (ProductID) REFERENCES products(product_id) ON DELETE SET NULL
        );
        '''
        cursor.execute(SQL_CREATE_REVIEWS_TABLE)

        con.commit()
        cursor.close()
        print("Tables created successfully.")
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")
    finally:
        if con is not None:
            con.close()

def main():
    database_design()

if __name__ == "__main__":
    main()
