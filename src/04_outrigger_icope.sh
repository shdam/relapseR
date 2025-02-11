#!/bin/bash

cd /home/projects/dp_immunoth/data/iCOPE
#mamba activate outrigger-env

GTF="../homo_sapiens/Homo_sapiens.GRCh38.107.gtf"

# Index with Outrigger
outrigger index --bam cd19/*bam --gtf $GTF --resume

# echo "Indexing mapped reads with outrigger"
# for file in mapped/*_SJ.out.tab; do
#   base_file=$(basename "$file")
#   SAMPLE="${base_file%_Aligned.sortedByCoord.out.bam}"
#   if [ ! -f outrigger/$(basename "$file").bal ]; then
#     outrigger index --sj-out-tab $file --gtf $GTF -o outrigger/$SAMPLE
#   else
#     echo "$file already indexed"
#   fi
# done

# Skip validate, as BAM files have been subset
# outrigger validate --genome hg19 \
#     -o ./outrigger\
#     --fasta ../homo_sapiens/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa

# Compute PSI
outrigger psi

