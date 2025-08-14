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
  regions = "chr16:28932346-28932612"
) %>%
  set_row_filters(strand == "+")

# 2. Right Inclusion Group: Junction reads spanning from Intron 2-3 to Exon 3
rq <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932911-28933114"
) %>%
  set_row_filters(strand == "+")

# 3. Exclusion Group: Junction reads that skip Intron 2-3 entirely, connecting Exon 2 to Exon 3
ex <- QueryBuilder(
  compilation = compilation,
  regions = "chr16:28932613-28932910"
) %>%
  set_row_filters(strand == "+")

# Calculate PSI using the percent_spliced_in() function
psi_result_intron2 <- percent_spliced_in(
  inclusion_group1 = list(lq),
  inclusion_group2 = list(rq),
  exclusion_group = list(ex),
  min_count = 20
)

# Display the PSI results
# print(psi_result_intron2_3)

# Display the result
# print(psi_result)