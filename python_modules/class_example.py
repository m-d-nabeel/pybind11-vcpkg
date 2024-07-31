import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


class DataSet:
    def __init__(self, data):
        self.df = pd.DataFrame(data)

    def add_row_sums(self):
        """Add a column with the sum of each row."""
        self.df["Row Sum"] = self.df.iloc[:, :-1].sum(axis=1)

    def add_column_means(self):
        """Add a row with the mean of each column."""
        mean_values = self.df.iloc[:, :-1].mean(axis=0)
        mean_df = pd.DataFrame([mean_values], columns=self.df.columns[:-1])
        self.df = pd.concat([self.df, mean_df], ignore_index=True)

    def filter_rows(self, column, threshold):
        """Filter rows based on a threshold value in a given column."""
        return self.df[self.df[column] > threshold]

    def calculate_column_sums(self):
        """Calculate the sum of each column."""
        return self.df.sum()

    def display(self):
        """Display the DataFrame."""
        print(self.df)

    def plot_data(self):
        """Generate and save a pairplot of the dataset."""
        sns.pairplot(self.df, hue="species")
        plt.savefig("/home/m-d-nabeel/Projects/pybind/python_modules/pairplot.png")
        print("Plot saved as 'pairplot.png'")


def run():
    # Load the Iris dataset
    iris = sns.load_dataset("iris")

    # Instantiate the DataSet class with the Iris data
    dataset = DataSet(iris)

    # Perform operations on the dataset
    dataset.add_row_sums()
    dataset.add_column_means()

    print("DataFrame after adding Row Sums and Column Means:")
    dataset.display()

    # Calculate column sums
    column_sums = dataset.calculate_column_sums()
    print("\nColumn Sums:")
    print(column_sums)

    # Filter rows where the sepal_length is greater than 5
    filtered_df = dataset.filter_rows("sepal_length", 5)
    print("\nFiltered DataFrame (sepal_length > 5):")
    print(filtered_df)

    # Plot the data
    print("\nGenerating pairplot of the Iris dataset...")
    dataset.plot_data()
