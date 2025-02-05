#!/bin/bash

cd /home/projects/dp_immunoth/data/iCOPE

GTF="homo_sapiens/Homo_sapiens.GRCh38.107.gtf"
BAM_DIR="bam"
OUTPUT_DIR="rmats"

# Create output directory
mkdir -p $OUTPUT_DIR

# Check index
echo "Indexing mapped reads with samtools"
for file in bam/*.bam; do
  if [ ! -f "$(basename "$forward").bai" ]; then
      samtools index "$file"
    else
      echo "$file already indexed"
    fi
done

# Run rMATS
rmats.py --b1 $BAM_DIR/*.bam --gtf $GTF --od $OUTPUT_DIR --t paired --nthread 38
