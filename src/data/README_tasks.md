You work as a data engineer in a largebookstore chain- The data analysts need to create reports of book sales using Power BI. The sales data comes from a source system as one wide dataset. A separate text file will be given with description of the columns.

Task 1:
- Create a star schema for book sales data to be used for reporting. 
- Choose which columns to include and the number of dimensions
- Implement the data model using SQL (for example PostgreSQL)
Deliverables:
-Drawing of logical data model of that star schema
-Submit a SQL file containing the schema of your model (the code you used to create the tables)
-Also write down the reasoning behind your model, for example, why did you choose those fact/dimension tables, did you modify the data or columns in any other way than that, does this solution now work well for given scenario, etc.

Task 2:
The customer loyalty programme status changes over time. These are based on the total purchases within each calendar year. How would you handle this?
Deliverables:
-Choose a strategy, and explain your reasoning

Use given columns.

# ANSWERS:
# TASK 1:
# SQL queries are in bookstore_tables.sql, from where you can see which columns are being used
# here´s also one optional dimension table called discount, it can either be used or not
# Star schema and also physical model is taken from PGAmind, file called bookstorechain_physicalmodel_starschema.png
# SQL tables were implemented through PGAdmin with SQL queries
# Logical model is in the file bookstorechain_logicalmodel.png

# Reasoning Behind the Design
- Fact Table: numerical (factual) table, includes sales measures such as quantity, total sales amount, and net sales amount for analysis
- Date Dimension: essential for time-based aggregation (e.g., monthly sales, year-over-year trends)
- Customer Dimension: helps analyze demographics like age, gender etc
- Book Dimension: tracks attributes of the actual books sold, to analyze bestselling genres, or giving information to authors, publishers
- Store Dimension: analysis based on geography, or sales channel (online or physical)
- Loyalty Program Dimension: How customer loyalty affects behaviour
- Discount Dimension: this is not necessary, but it would be good for analyzing profit
 
# tASK 2: 
# Strategy
- using a slowly changing dimension (SCD) Type 2 for the DimLoyaltyProgram table. This way we will see historical changes in loyalty program levels of each customers and at the same time having a timeline for customer behaviour.

# How to implement it
- add starting and ending date -columns to the Loyalry Program table
- because we´re using SCD Type 2, no rows are deleted, but added, which means inserting new updated details to the table when a customer´s status changes, this together with timee details, we could analyze how behaviour has changed 

# Reasoning
- as an advantage, history is kept for reporting and trend analysis
- this enables queries to analyze customer behavior over time (e.g., when customers upgraded from standard to something else
- if we did this with SCR Type 1, it would overwrite all history information, so we wouldn´t have any context to prevopus statuses, then we can´t calculate customer lifetime value