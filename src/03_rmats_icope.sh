#!/bin/bash

cd /home/projects/dp_immunoth/data/iCOPE

GTF="../homo_sapiens/Homo_sapiens.GRCh38.107.gtf"

# Create output directory
mkdir -p rmats

# Check index

echo "Indexing mapped reads with samtools"
for file in bam/*.bam; do
  if [ ! -f bam/$(basename "$file").bai ]; then
    samtools index "$file"
  else
    echo "$file already indexed"
  fi
done

# Run rMATS
for file in bam/*.bam; do
  base_file=$(basename "$file")
  SAMPLE="${base_file%_Aligned.sortedByCoord.out.bam}"
  if [ ! -f "rmats/$SAMPLE/SE.MATS.JC.txt" ]; then
    echo "Running rMATS on $SAMPLE"
    rmats.py --b1 <(zcat "$file") --gtf $GTF --od "rmats/$SAMPLE" --tmp .rmats --nthread 40 --statoff  --readLength 255 --variable-read-length
  else
    echo "rMATS already run on $file"
  fi
done

