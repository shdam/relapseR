patb0 <- readr::read_tsv("raw_data/portcullis/CRR025971/annotated_junctions.tsv")
library(dplyr)
patb0 <- patb0 %>%
  filter(gene_names == "CD19") %>%
  mutate(patient = "B0")

patd0 <- readr::read_tsv("raw_data/portcullis/CRR025975/annotated_junctions.tsv")
patc0 <- readr::read_tsv("raw_data/portcullis/CRR025977/annotated_junctions.tsv")
patc0 <- patc0 %>%
  filter(gene_names == "CD19") %>%
  mutate(patient = "C0")

pata0 <- readr::read_tsv("raw_data/portcullis/CRR025973/annotated_junctions.tsv")
pata0 <- pata0 %>%
  filter(gene_names == "CD19") %>%
  mutate(patient = "A0")

pats <- pata0 %>%
  semi_join(patb0, by = c("start", "end")) %>%
  semi_join(patc0, by = c("start", "end")) %>%
  anti_join(patd0, by = c("start", "end"))


port_patB0 <- readr::read_table("raw_data/portcullis/CRR025971/3-filt/portcullis_filtered.pass.junctions.tab") %>%
  filter(start > 28930734, start < 28940347)



## Pats

patient_ids <- c("B0", "B14", "A0", "A14", "D0", "D14", "C0", "C14")

pats <- lapply(1:8, function(x){
  filename <- paste0("raw_data/portcullis/CRR02597", x, "/annotated_junctions.tsv")
  readr::read_tsv(filename) %>%
    filter(gene_names == "CD19") %>%
    mutate(patient_id = factor(patient_ids[x], levels = patient_ids))
}) %>% bind_rows()

table(pats$patient_id)

readr::read_tsv("raw_data/portcullis/CRR025971/annotated_junctions.tsv")
md <- readr::read_table("GDCdata/survival%2FDLBC_survival.txt")


semi_join(filter(pats, patient_id == "A14"), filter(pats, patient_id == "A0"), by = c("start", "end")) %>% View


