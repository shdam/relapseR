# Load required libraries
library(snapcount)
library(magrittr)
library(dplyr)

# Define the strand of the gene
strand <- "+"

# Define the TCGA compilation
compilation <- "tcga"

# 1. Left Inclusion Group: Junction reads spanning from Intron 1-2 to Exon 2
lq <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932089-28932346"
) %>%
  set_row_filters(strand == "+")

# 2. Right Inclusion Group: Junction reads spanning from Exon 2 to Intron 2-3
rq <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932612-28932910"
) %>%
  set_row_filters(strand == "+")

# 3. Exclusion Group: Junction reads skipping Exon 2 entirely, from Intron 1-2 to Intron 2-3
ex <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932346-28932612"
) %>%
  set_row_filters(strand == "+")

# Calculate PSI using the percent_spliced_in() function
psi_result_exon2 <- percent_spliced_in(
  inclusion_group1 = list(lq),
  inclusion_group2 = list(rq),
  exclusion_group = list(ex),
  min_count = 20
)

# Display the PSI results
# print(psi_result)

psi_BALL_exon2 <- psi_result_exon2 %>%
  dplyr::filter(psi != -1) %>%
  semi_join(metadata, by="sample_id") %>%
  left_join(metadata, by="sample_id") %>%
  mutate(type = "TCGA DLBCL")
psi_BALL_intron2 <- psi_result_intron2 %>%
  dplyr::filter(psi != -1) %>%
  semi_join(metadata, by="sample_id") %>%
  left_join(metadata, by="sample_id") %>%
  mutate(type = "TCGA DLBCL")
