"Load data into data folder.

Usage: src/01_load_data.R --output_path=<output_path>

Options:
--output_path=<output_path>

" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)
library(tidymodels)
library(regexcite20250416) # REPLACE WITH OWN LIBRARY

opt <- docopt::docopt(doc)

data <- penguins

# Initial cleaning: Remove missing values
data <- data %>% drop_na()

# Save data to data folder
readr::write_csv(data, opt$output_path) # work/data/raw/penguins.csv