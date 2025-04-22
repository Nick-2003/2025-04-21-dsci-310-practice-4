"Load data into data folder.

Usage: src/05_packages.R --output_path=<output_path>

Options:
--output_path=<output_path>

" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)
library(tidymodels)
library(regexcite20250416) # REPLACE WITH OWN LIBRARY

opt <- docopt::docopt(doc)

# Explicit namespace use
calls <- c("regexcite20250416::is_leap(2000)", 
           "regexcite20250416::is_leap(1900)", 
           "regexcite20250416::temp_conv(41, 'F', 'C')")

# Evaluate each safely
outputs <- sapply(calls, function(call) {
  tryCatch({
    eval(parse(text = call))
  }, error = function(e) {
    paste("Error:", e$message)
  })
})

# Create dataframe
func_outputs <- data.frame(
  Function = calls,
  Output = outputs,
  stringsAsFactors = FALSE
)
func_outputs

# Save data to data folder
readr::write_csv(func_outputs, opt$output_path) # work/output/func_outputs.csv
