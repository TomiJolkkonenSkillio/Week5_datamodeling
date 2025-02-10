import random
import faker

# Initialize Faker
fake = faker.Faker()

# List of European countries
european_countries = {
    "France": "Paris",
    "Germany": "Berlin",
    "Italy": "Rome",
    "Spain": "Madrid",
    "Netherlands": "Amsterdam",
    "Sweden": "Stockholm",
    "Norway": "Oslo",
    "Finland": "Helsinki",
    "Denmark": "Copenhagen",
    "Poland": "Warsaw",
    "Belgium": "Brussels",
    "Portugal": "Lisbon",
    "Austria": "Vienna",
    "Switzerland": "Zurich",
    "Ireland": "Dublin",
    "Czech Republic": "Prague",
    "Hungary": "Budapest",
    "Greece": "Athens"
}

# Generate 100 European customers
customers = []
for _ in range(100):
    name = fake.name()
    first_name, last_name = name.split(" ", 1)  # Extract first and last name
    email = f"{first_name.lower()}.{last_name.lower()}@example.com"  # Matching email

    country, capital = random.choice(list(european_countries.items()))  # Pick a random European country
    city = capital  # Set the city to the country's capital

    customer_segment = random.choice(["Standard", "Premium"])

    customers.append(f"('{name}', '{email}', '{city}', '{country}', '{customer_segment}')")

# Generate SQL INSERT statement
sql_query = "INSERT INTO customers (Name, Email, City, Country, CustomerSegment) VALUES\n"
sql_query += ",\n".join(customers) + ";"

# Save to file
with open("populate_customers_europe.sql", "w", encoding="utf-8") as file:
    file.write(sql_query)

print("SQL file with European customers generated successfully!")
