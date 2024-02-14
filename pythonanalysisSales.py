#we have a dataset containing information about sales transactions for a retail store.
# DataSet :  sales_data.csv containing columns like Date, Product, Quantity, and Revenue. 

import pandas as pd
import sqlite3
import matplotlib.pyplot as plt
import seaborn as sns

# Read CSV file into Pandas DataFrame
df = pd.read_csv('c:\sales_data.csv')

# Display the first few rows of the DataFrame
print(df.head())
# Calculate summary statistics
summary_stats = df.describe()

# Filter data for a specific product
product_A_data = df[df['Product'] == 'Product A']

# Group data by date and calculate total revenue for each day
daily_revenue = df.groupby('Date')['Revenue'].sum()

# Provide authentication details
username = 'ndata'
password = '#####'

# Connect to SQLite database with authentication
conn = sqlite3.connect('sales_data.db',user=username,password=password)

# Write DataFrame to SQLite database
df.to_sql('sales', conn, if_exists='replace', index=False)

# Write SQL query to retrieve total revenue for each product
query = """
        SELECT Product, SUM(Revenue) AS TotalRevenue
        FROM sales
        GROUP BY Product
        """

# Execute SQL query and fetch results into a DataFrame
product_revenue = pd.read_sql_query(query, conn)

# Close database connection
conn.close()

# Display the results
print(product_revenue)


# Set Seaborn style
sns.set_style('whitegrid')

# Plot total revenue by product
plt.figure(figsize=(10, 6))
sns.barplot(x='Product', y='TotalRevenue', data=product_revenue)
plt.title('Total Revenue by Product')
plt.xlabel('Product')
plt.ylabel('Total Revenue')
plt.show()
