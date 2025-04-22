"Perform exploratory data analysis (EDA) and prepare the data for modeling.

Usage: src/02_methods.R --input_path=<input_path> --output_path_summary=<output_path_summary> --output_path_visualizations=<output_path_visualizations> --output_path_model=<output_path_model>

Options:
--input_path=<input_path>
--output_path_summary=<output_path_summary>
--output_path_visualizations=<output_path_visualizations>
--output_path_model=<output_path_model>
" -> doc

library(docopt)
library(dplyr)
library(ggplot2)
library(readr)

opt <- docopt::docopt(doc)

data <- readr::read_csv(opt$input_path) # work/data/raw/penguins.csv

# Summary statistics
dplyr::glimpse(data)
summary <- dplyr::summarise(data, mean_bill_length = mean(bill_length_mm), mean_bill_depth = mean(bill_depth_mm), mean_flipper_length = mean(flipper_length_mm), mean_body_mass = mean(body_mass_g))


# Visualizations
boxplot_viz <- ggplot2::ggplot(data, ggplot2::aes(x = species, y = bill_length_mm, fill = species)) +
  ggplot2::geom_boxplot() +
  ggplot2::theme_minimal()

# Prepare data for modeling
data <- data %>%
  dplyr::select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  dplyr::mutate(species = as.factor(species))

# Save data to data folder
readr::write_csv(summary, opt$output_path_summary) # work/output/summary.csv
ggplot2::ggsave(opt$output_path_visualizations, boxplot_viz) # work/output/boxplot.png
readr::write_csv(data, opt$output_path_model) # work/data/processed/penguins_cleaned.csv
