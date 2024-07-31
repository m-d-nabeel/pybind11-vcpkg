import numpy as np
import pandas as pd

print("EXAMPLE OF USING INSTALLED LIBRARIES")

# Create a NumPy array
data = np.array([[10, 20, 30], [40, 50, 60], [70, 80, 90], [100, 110, 120]])

# Perform some operations using NumPy
mean_values = np.mean(data, axis=0)  # Mean of each column (results in 3 elements)
sum_values = np.sum(data, axis=1)  # Sum of each row (results in 4 elements)

# Convert the NumPy array to a Pandas DataFrame
df = pd.DataFrame(data, columns=["A", "B", "C"])

# Add the calculated sum of each row as a new column to the DataFrame
df["Row Sum"] = sum_values

# Display the DataFrame
print(df)

# Add the mean values as a new row to the DataFrame
# We first convert mean_values to a DataFrame and then append
mean_df = pd.DataFrame([mean_values], columns=df.columns[:-1])

# Appending mean values as the last row of the DataFrame
df = pd.concat([df, mean_df], ignore_index=True)

# Display the DataFrame with the mean row added
print("\nDataFrame with Mean values added as a row:")
print(df)

# Perform additional Pandas operations
# Calculate the sum of each column
column_sums = df.sum()

# Print the column sums
print("\nColumn Sums:")
print(column_sums)

# Filter rows where the value in column 'A' is greater than 50
filtered_df = df[df["A"] > 50]

print("\nFiltered DataFrame (A > 50):")
print(filtered_df)
