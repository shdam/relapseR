#!/bin/bash

cd /home/projects/dp_immunoth/data/iCOPE
#mamba activate outrigger-env

GTF="../homo_sapiens/Homo_sapiens.GRCh38.107.gtf"

# Index with Outrigger
# outrigger index --bam cd19/*bam --gtf $GTF --resume

echo "Indexing mapped reads with outrigger"
for file in mapped/*SJ.out.tab; do
  base_file=$(basename "$file")
  SAMPLE="${base_file%_SJ.out.tab}"
  if [ ! -f outrigger/$SAMPLE/psi/outrigger_psi.csv ]; then
    # outrigger index --bam $file --gtf $GTF -o outrigger --n-jobs 38 --resume
    outrigger index -j $file --gtf $GTF -o outrigger --n-jobs 39 --resume
    outrigger psi -o outrigger

    mkdir -p outrigger/$SAMPLE
    cp -r outrigger/junctions outrigger/$SAMPLE/
    rm outrigger/junctions/reads.csv
    mv outrigger/psi outrigger/$SAMPLE/
    # junction:16:28932089-28932910:+
  else
    echo "$file already indexed"
  fi
done

# Skip validate, as BAM files have been subset
# outrigger validate --genome hg19 \
#     -o ./outrigger\
#     --fasta ../homo_sapiens/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa

# Compute PSI
# outrigger psi -o outrigger -b cd19/*bam

