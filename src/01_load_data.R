"Load data into data folder.

Usage: src/01_load_data.R --output_path=<output_path>

Options:
--output_path=<output_path>

" -> doc

# Load required libraries
library(docopt)
library(palmerpenguins)
library(tidyr)
library(readr)

# Parse command line arguments
opt <- docopt(doc)

# Load data
data <- penguins

# Initial cleaning: Remove missing values
data <- data %>% drop_na()

# Save cleaned data to specified path
write_csv(data, opt$output_path) # work/data/raw/penguins.csv