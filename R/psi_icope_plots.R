library("dplyr")
library("ggplot2")
library("ggpubr")

# Metadata
# md_icope <- readxl::read_xlsx("path/to/metadata.xlsx")

# iCOPE
psi_icope <- readRDS("data/psi_icope.RDS")

# Rename columns to match snapcount formats (optional)
psi_icope <- psi_icope |>
  mutate(type = "B-ALL") |>
  rename(exclusion_group_coverage = isoform1_junction13,
         inclusion_group1_coverage = isoform2_junction12,
         inclusion_group2_coverage = isoform2_junction23) |>
  select(-event_id)

# Join with metadata
psi_icope <- psi_icope |>
  left_join(md_icope, by = c("sample_id" = "SAMPLEID"))

# Boxplot
ggplot(psi_icope, aes(x = VARIABLE, y = psi)) +
  geom_boxplot() +
  labs(title = "boxplot") +
  theme_pubr()

# Scatterplot
ggplot(psi_icope, aes(x = VARIABLE, y = psi)) +
  geom_point() +
  labs(title = "scatterplot") +
  theme_pubr()

