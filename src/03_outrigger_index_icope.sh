#!/bin/bash

cd ../tools/outrigger
source activate outrigger-env
cd /home/projects/dp_immunoth/data/iCOPE

GTF="../homo_sapiens/Homo_sapiens.GRCh38.107.gtf"

# Create output directory
#mkdir -p outrigger

# Check index

outrigger index --sj-out-tab mapped/*SJ.out.tab --gtf $GTF -o outrigger

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

outrigger validate --genome hs \
    -o ./outrigger/index\
    --fasta ../homo_sapiens/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa


# Run outrigger
# for file in bam/*.bam; do
#   base_file=$(basename "$file")
#   SAMPLE="${base_file%_Aligned.sortedByCoord.out.bam}"
#   if [ ! -f "rmats/$SAMPLE/SE.MATS.JC.txt" ]; then
#     echo "Running rMATS on $SAMPLE"
#     rmats.py --b1 <(zcat "$file") --gtf $GTF --od "rmats/$SAMPLE" --tmp .rmats --nthread 40 --statoff  --readLength 255 --variable-read-length
#   else
#     echo "rMATS already run on $file"
#   fi
# done

