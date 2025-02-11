import random
from datetime import datetime, timedelta


# Constants
NUM_ORDERS = 1000
NUM_CUSTOMERS = 100  # Assuming CustomerID 1-100 exist
MAX_QUANTITY = 10  # Max quantity per product per order
MAX_ORDER_ITEMS = 5  # Each order can have up to 5 different products
product_list = [
('Running Shoes Pro', 'Footwear', 120.99, 1500),
('Football Boots Elite', 'Footwear', 199.99, 1200),
('Basketball Sneakers X', 'Footwear', 89.50, 900),
('Trail Running Shoes Ultra', 'Footwear', 159.99, 700),
('Cycling Shoes Max', 'Footwear', 179.99, 500),

('Compression Shirt Pro', 'Apparel', 45.00, 2500),
('Running Shorts X', 'Apparel', 35.99, 2000),
('Thermal Jacket Ultra', 'Apparel', 99.50, 800),
('Football Jersey Elite', 'Apparel', 69.99, 1500),
('Base Layer Top Max', 'Apparel', 55.00, 1800),

('Dumbbells Set X', 'Equipment', 250.00, 300),
('Adjustable Kettlebell Pro', 'Equipment', 79.99, 600),
('Resistance Bands Elite', 'Equipment', 29.99, 2200),
('Speed Jump Rope Ultra', 'Equipment', 19.99, 2500),
('Yoga Mat Max', 'Equipment', 49.99, 1800),

('Protein Bars Pack', 'Nutrition', 25.99, 2700),
('Energy Drink Case', 'Nutrition', 39.99, 2300),
('Electrolyte Powder Pro', 'Nutrition', 15.99, 1800),
('Creatine Monohydrate X', 'Nutrition', 34.50, 1500),
('Whey Protein 2kg Elite', 'Nutrition', 79.99, 1200),

('Weightlifting Gloves Pro', 'Accessories', 19.99, 2800),
('Running Headband X', 'Accessories', 9.99, 3000),
('Gym Towel Ultra', 'Accessories', 14.50, 2500),
('Smartwatch Max', 'Accessories', 299.99, 500),
('Compression Socks Elite', 'Accessories', 24.99, 2000),

('Camping Tent Pro', 'Outdoor Gear', 349.99, 450),
('Hiking Backpack X', 'Outdoor Gear', 129.99, 700),
('Sleeping Bag Ultra', 'Outdoor Gear', 79.50, 1200),
('Trekking Poles Max', 'Outdoor Gear', 59.99, 1600),
('Waterproof Jacket Elite', 'Outdoor Gear', 99.99, 1000),

('Massage Gun Pro', 'Recovery', 199.99, 600),
('Foam Roller X', 'Recovery', 29.99, 2700),
('Compression Sleeves Ultra', 'Recovery', 49.99, 1900),
('Hot & Cold Therapy Pack Max', 'Recovery', 19.99, 2200),
('Muscle Rub Cream Elite', 'Recovery', 15.99, 2500)
]
# ✅ Convert the list into a dictionary with ProductID as key
products = {i + 1: product_list[i] for i in range(len(product_list))}
NUM_PRODUCTS = len(products)  # Ensure we match the actual product count

# Generate orders in chronological order
orders = []
order_items = []
start_date = datetime.today() - timedelta(days=730)  # Orders from last 2 years

for order_id in range(1, NUM_ORDERS + 1):
    order_date = start_date + timedelta(days=int((order_id / NUM_ORDERS) * 730) + random.randint(0, 3))
    customer_id = random.randint(1, NUM_CUSTOMERS)
    num_items = random.randint(1, MAX_ORDER_ITEMS)  # 1-5 products per order

    # Generate order items and calculate order total correctly
    order_value = 0
    selected_products = random.sample(list(products.keys()), num_items)  # Pick unique products per order

    for product_id in selected_products:
        quantity = random.randint(1, MAX_QUANTITY)
        unit_price = products[product_id][2]  # Get the actual product price from the list
        total_price = round(unit_price * quantity, 2)
        order_value += total_price

        order_items.append(f"({order_id}, {product_id}, {quantity})")

    # Add order with total value
    orders.append(f"({order_id}, '{order_date.strftime('%Y-%m-%d')}', {round(order_value, 2)}, {customer_id})")

# Convert to SQL INSERT statements
orders_sql = "INSERT INTO Orders (OrderID, OrderDate, OrderValue, CustomerID) VALUES\n" + ",\n".join(orders) + ";"

order_items_sql = "INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES\n" + ",\n".join(order_items) + ";"

# Save SQL to files
with open("populate_orders_matched.sql", "w", encoding="utf-8") as file:
    file.write(orders_sql)

with open("populate_order_items_matched.sql", "w", encoding="utf-8") as file:
    file.write(order_items_sql)

print("SQL files generated: populate_orders_matched.sql, populate_order_items_matched.sql")
