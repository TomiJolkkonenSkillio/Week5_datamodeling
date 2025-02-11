import random
from datetime import datetime, timedelta

# Constants
NUM_REVIEWS = 200
NUM_CUSTOMERS = 100  # Assuming CustomerID 1-100 exist
NUM_PRODUCTS = 35  # Assuming ProductID 1-50 exist

# Positive and Negative Comment Samples
positive_comments = [
    "Excellent product! Highly recommend.",
    "Very satisfied with my purchase.",
    "Great quality and value for money.",
    "Exceeded my expectations.",
    "Perfect, just what I needed!",
    "Love it! Will buy again.",
    "Superb product, works as advertised.",
    "Really good, fast delivery too.",
    "Five stars, best purchase ever.",
    "Amazing! Worth every penny."
]

negative_comments = [
    "Terrible quality, do not buy!",
    "Very disappointed with this.",
    "Not as described, poor quality.",
    "Broke after a few uses.",
    "Does not work properly.",
    "Would not recommend at all.",
    "Not worth the money.",
    "Arrived damaged, poor packaging.",
    "Defective item, had to return.",
    "Worst purchase ever!"
]

# Generate review data
reviews = []
start_date = datetime.today() - timedelta(days=730)  # Reviews from last 2 years

for review_id in range(1, NUM_REVIEWS + 1):
    review_date = start_date + timedelta(days=random.randint(0, 730))  # Random date in last 2 years
    rating = random.randint(1, 5)
    customer_id = random.randint(1, NUM_CUSTOMERS)
    product_id = random.randint(1, NUM_PRODUCTS)

    # Assign comments based on rating
    if rating >= 4:
        comment = random.choice(positive_comments)
    elif rating <= 2:
        comment = random.choice(negative_comments)
    else:
        comment = None  # NULL for neutral reviews

    # Append as tuple (for sorting)
    reviews.append((review_id, review_date, rating, comment, customer_id, product_id))

# Sort reviews by ReviewDate
reviews.sort(key=lambda x: x[1])

# Convert to SQL format
sql_values = []
for review_id, review_date, rating, comment, customer_id, product_id in reviews:
    formatted_date = review_date.strftime('%Y-%m-%d')
    formatted_comment = f"'{comment}'" if comment else "NULL"
    sql_values.append(f"('{formatted_date}', {rating}, {formatted_comment}, {customer_id}, {product_id})")

# Create SQL insert statement
reviews_sql = "INSERT INTO Reviews (ReviewID, ReviewDate, Rating, Comment, CustomerID, ProductID) VALUES\n" + ",\n".join(sql_values) + ";"

# Save to file
with open("populate_reviews.sql", "w", encoding="utf-8") as file:
    file.write(reviews_sql)

print("✅ SQL file generated: populate_reviews.sql (sorted by ReviewDate)")
