.PHONY: all clean

all: 
	make clean
	make index.html

clean:
	rm -rf output/*
	rm -rf data/*
	rm -rf docs/*

index.html: work/data/raw/penguins.csv \
			work/output/summary.csv \
			work/output/boxplot_viz.png \
			work/data/processed/penguins_cleaned.csv \
			work/data/processed/penguins_train.csv \
			work/data/processed/penguins_test.csv \
			work/output/penguin_fit.rds \
			work/output/conf_mat.csv \
			work/output/func_outputs.csv \
			work/reports/analysis.html \
			work/reports/analysis.pdf
			cp work/reports/analysis.html work/docs/index.html

# For 01_load_data.R
work/data/raw/penguins.csv: src/01_load_data.R
	Rscript src/01_load_data.R --output_path=work/data/raw/penguins.csv

# For 02_clean_data.R
work/output/summary.csv work/output/boxplot.png work/data/processed/penguins_cleaned.csv: src/02_clean_data.R work/data/raw/penguins.csv
	Rscript src/02_clean_data.R \
	--input_path=work/data/raw/penguins.csv \
	--output_path_summary=work/output/summary.csv \
	--output_path_visualizations=work/output/boxplot.png \
	--output_path_model=work/data/processed/penguins_cleaned.csv

# For 03_split_data.R
work/data/processed/penguins_train.csv work/data/processed/penguins_test.csv work/output/penguin_fit.rds: src/03_split_data.R work/data/processed/penguins_cleaned.csv
	Rscript src/03_split_data.R \
	--input_path=work/data/processed/penguins_cleaned.csv \
	--output_path_train=work/data/processed/penguins_train.csv \
	--output_path_test=work/data/processed/penguins_test.csv \
	--output_path_model=work/output/penguin_fit.rds

# For 04_summarize_data.R
work/output/conf_mat.csv: src/04_summarize_data.R work/data/processed/penguins_train.csv work/data/processed/penguins_test.csv work/output/penguin_fit.rds
	Rscript src/04_summarize_data.R \
	--input_path_train=work/data/processed/penguins_train.csv \
	--input_path_test=work/data/processed/penguins_test.csv \
	--input_path_model=work/output/penguin_fit.rds \
	--output_path=<output_path>

# For 05_visualize_data.R
work/output/func_outputs.csv: src/05_visualize_data.R
	Rscript src/05_visualize_data.R \
	--output_path=work/output/func_outputs.csv

# render quarto report in HTML and PDF 
work/reports/analysis.html: work/output work/reports/analysis.qmd
	quarto render work/reports/analysis.qmd --to html

work/reports/analysis.pdf: work/output work/reports/analysis.qmd
	quarto render work/reports/analysis.qmd --to pdf