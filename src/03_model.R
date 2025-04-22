"Load data into data folder

Usage: src/03_model.R --input_path=<input_path> --output_path_train=<output_path_train> --output_path_test=<output_path_test> --output_path_model=<output_path_model>

Options:
--input_path=<input_path>
--output_path_train=<output_path_train>
--output_path_test=<output_path_test>
--output_path_model=<output_path_model>

" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)
library(tidymodels)
library(regexcite20250416) # REPLACE WITH OWN LIBRARY

opt <- docopt::docopt(doc)

data <- readr::read_csv(opt$input_path) # work/data/processed/penguins_cleaned.csv

# Split data
set.seed(123)
data_split <- initial_split(data, strata = species)
train_data <- training(data_split)
test_data <- testing(data_split)

# Define model
penguin_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
  set_engine("kknn")

# Create workflow
penguin_workflow <- workflow() %>%
  add_model(penguin_model) %>%
  add_formula(species ~ .)

# Fit model
penguin_fit <- penguin_workflow %>%
  fit(data = train_data)

# Save data to data folder
readr::write_csv(train_data, opt$output_path_train) # work/data/processed/penguins_train.csv
readr::write_csv(test_data, opt$output_path_test) # work/data/processed/penguins_test.csv
readr::write_rds(penguin_fit, opt$output_path_model) # work/output/penguin_fit.rds
