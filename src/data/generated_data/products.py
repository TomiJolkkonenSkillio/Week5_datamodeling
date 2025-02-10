import random
import faker

# Initialize Faker
fake = faker.Faker()

# Define sports-related product categories
sports_categories = [
    "Footwear", "Apparel", "Equipment", "Nutrition", "Accessories", "Outdoor Gear", "Recovery"
]

# Generate 50 sports products
products = []
for _ in range(50):
    category = random.choice(sports_categories)  # Pick a random category
    product_name = fake.word().capitalize() + " " + random.choice(["Pro", "Elite", "Max", "Ultra", "X"])
    unit_price = round(random.uniform(15, 999), 2)  # Price between 15 and 999
    inventory = random.randint(0, 3000)  # Inventory between 0 and 3000

    products.append(f"('{product_name}', '{category}', {unit_price}, {inventory})")

# Generate SQL INSERT statement
product_sql = "INSERT INTO products (ProductName, ProductCategory, UnitPrice, Inventory) VALUES\n"
product_sql += ",\n".join(products) + ";"

# Save SQL to a file
with open("populate_sports_products.sql", "w", encoding="utf-8") as file:
    file.write(product_sql)

print("SQL file generated successfully: populate_sports_products.sql")
