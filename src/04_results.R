"Load data into data folder

Usage: src/04_results.R --input_path_train=<input_path_train> --input_path_test=<input_path_test> --input_path_model=<input_path_model> --output_path=<output_path>

Options:
--input_path_train=<input_path_train>
--input_path_test=<input_path_test>
--input_path_model=<input_path_model>
--output_path=<output_path>

" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)
library(tidymodels)
library(regexcite20250416) # REPLACE WITH OWN LIBRARY

opt <- docopt::docopt(doc)

# Load data
train_data <- readr::read_csv(opt$input_path_train) # work/data/processed/penguins_train.csv
test_data <- readr::read_csv(opt$input_path_test) # work/data/processed/penguins_test.csv
penguin_fit <- readr::read_rds(opt$input_path_model) # work/output/penguin_fit.rds

# Predict on test data
predictions <- predict(penguin_fit, test_data, type = "class") %>%
  bind_cols(test_data)

# Confusion matrix
conf_mat <- conf_mat(predictions, truth = species, estimate = .pred_class)
conf_mat

# Save data to data folder
readr::write_csv(conf_mat, opt$output_path) # work/output/conf_mat.csv