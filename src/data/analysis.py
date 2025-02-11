import psycopg2
from config import config

def execute_query(query, params=None):
    """Execute a SQL query and return results."""
    con = None
    try:
        con = psycopg2.connect(**config())
        cursor = con.cursor()
        cursor.execute(query, params)
        results = cursor.fetchall()
        cursor.close()
        return results
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")
        return None
    finally:
        if con is not None:
            con.close()

# 1. Finding the top-selling products
# Top-selling products based on the total quantity sold
def get_top_selling_products():
    query = """
        SELECT 
            p.ProductName, 
            SUM(oi.Quantity) AS total_quantity_sold,
            SUM(oi.Quantity* p.UnitPrice) AS total_sales
        FROM 
            products p
        JOIN 
            orderitems oi ON p.ProductID = oi.ProductID
        GROUP BY 
            p.ProductName
        ORDER BY 
            total_quantity_sold DESC
        LIMIT 10;
    """
    return execute_query(query)

# 2. Calculating inventory levels
# Current inventory levels for all products
def get_inventory_levels():
    query = """
        SELECT 
            ProductName, 
            Inventory
        FROM 
            products
        ORDER BY 
            ProductName;
    """
    return execute_query(query)

# 3. Finding the most valuable customers
# Customers who have spent the most money on orders
def get_most_valuable_customers():
    query = """
        SELECT 
            c.Name, 
            c.Country,
            c.CustomerSegment,
            SUM(o.OrderValue) AS total_spent
        FROM 
            customers c
        JOIN 
            orders o ON c.CustomerID = o.CustomerID
        GROUP BY 
            c.Name, c.Country, c.CustomerSegment
        ORDER BY 
            total_spent DESC
        LIMIT 10;
    """
    return execute_query(query)

def main():
    # print("Top-Selling Products:")
    # top_selling = get_top_selling_products()
    # for product in top_selling:
    #     print(f"Product: {product[0]}, Total Quantity Sold: {product[1]}, Total Sales: {product[2]}")

    # print("\nInventory Levels:")
    # inventory = get_inventory_levels()
    # for item in inventory:
    #     print(f"Product: {item[0]}, Inventory: {item[1]}")

    print("\nMost Valuable Customers:")
    valuable_customers = get_most_valuable_customers()
    for customer in valuable_customers:
        print(f"Customer: {customer[0]}, Country: {customer[1]}, Segment: {customer[2]} Total Spent: {customer[3]}")

if __name__ == "__main__":
    main()
