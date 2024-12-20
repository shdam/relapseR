#
rm(list=ls())
# Run all
knitr::knit("R/01_mapping_reads.Rmd")
knitr::knit("R/02_Sashimi_plot.Rmd")
knitr::knit("R/03_PSI_plot.Rmd")
