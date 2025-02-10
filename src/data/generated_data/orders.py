import random
from datetime import datetime, timedelta

# Constants
NUM_ORDERS = 1000
NUM_CUSTOMERS = 100  # Assuming CustomerID 1-100 exist
NUM_PRODUCTS = 50  # Assuming ProductID 1-50 exist
MAX_QUANTITY = 10  # Max quantity per product per order
MAX_ORDER_ITEMS = 5  # Each order can have up to 5 different products

# Generate random orders in chronological order
orders = []
order_items = []
start_date = datetime.today() - timedelta(days=730)  # Orders from last 2 years

for order_id in range(1, NUM_ORDERS + 1):
    # Orders are spaced evenly, with some randomness
    order_date = start_date + timedelta(days=int((order_id / NUM_ORDERS) * 730) + random.randint(0, 3))
    customer_id = random.randint(1, NUM_CUSTOMERS)
    num_items = random.randint(1, MAX_ORDER_ITEMS)  # Random 1-5 products per order

    # Generate order items
    order_value = 0
    for _ in range(num_items):
        product_id = random.randint(1, NUM_PRODUCTS)
        quantity = random.randint(1, MAX_QUANTITY)
        unit_price = random.uniform(15, 999)  # Random price as we don't have actual products table
        total_price = round(unit_price * quantity, 2)
        order_value += total_price

        order_items.append(f"({quantity}, {order_id}, {product_id})")

    # Add order with total value
    orders.append(f"('{order_date.strftime('%Y-%m-%d')}', {round(order_value, 2)}, {customer_id})")

# Convert to SQL INSERT statements
orders_sql = "INSERT INTO Orders (OrderDate, OrderValue, CustomerID) VALUES\n" + ",\n".join(orders) + ";"

order_items_sql = "INSERT INTO OrderItems (Quantity, OrderID, ProductID) VALUES\n" + ",\n".join(order_items) + ";"

# Save SQL to files
with open("populate_orders_chronological.sql", "w", encoding="utf-8") as file:
    file.write(orders_sql)

with open("populate_order_items.sql", "w", encoding="utf-8") as file:
    file.write(order_items_sql)

print("SQL files generated: populate_orders_chronological.sql, populate_order_items.sql")
