# Load required libraries
library(snapcount)
library(magrittr)

# Define the strand of the gene
strand <- "+"

# Define the TCGA compilation
compilation <- "tcga"

# 1. Left Inclusion Group: Junction reads spanning from Exon 2 to Intron 2-3
lq <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932089-28932346"
) %>%
  set_row_filters(strand == "+")

# 2. Right Inclusion Group: Junction reads spanning from Intron 2-3 to Exon 3
rq <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932911-28933114"
) %>%
  set_row_filters(strand == "+")

# 3. Double Exclusion Group: Junction reads that skip both Exon 2 and Intron 2-3, connecting Intron 1-2 directly to Exon 3
ex_double <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932089-28932910"
) %>%
  set_row_filters(strand == "+")

# Calculate PSI using the percent_spliced_in() function
psi_result_combined <- percent_spliced_in(
  inclusion_group1 = list(lq),
  inclusion_group2 = list(rq),
  exclusion_group = list(ex_double),
  min_count = 20
)

# Display the PSI results
# print(psi_result_combined)
psi_BALL_combined <- psi_result_combined %>%
  dplyr::filter(psi != -1) %>% 
  semi_join(metadata, by="sample_id") %>% 
  left_join(metadata, by="sample_id") %>% 
  mutate(type = "TCGA DLBCL")
psi_BALL_combined$psi
