#!/bin/bash

cd /home/projects/dp_immunoth/data/iCOPE

GTF="../homo_sapiens/Homo_sapiens.GRCh38.107.gtf"
BAM_DIR="bam"
OUTPUT_DIR="rmats"

# Create output directory
mkdir -p $OUTPUT_DIR

# Check index

for file in "$BAM_DIR/*.bam"; do
  if [ ! -f "$(basename $file).bai" ]; then
    echo "Indexing mapped reads with samtools"
    samtools index "$file"
  else
    echo "$file already indexed"
  fi
done

# Run rMATS
for file in "$BAM_DIR/*.bam"; do

  base_file="$(basename $file)"
  tmp_file="${base_file%_Aligned.sortedByCoord.out.bam}"
  if [ ! -f "$OUTPUT_DIR/tmp_file/SE.MATS.JC.txt" ]; then
    echo "Running rMATS on $tmp_file"
    echo "$OUTPUT_DIR/$tmp_file"
    rmats.py --b1 $file --gtf $GTF --od "$OUTPUT_DIR/$tmp_file" --tmp "$OUTPUT_DIR/$tmp_file"_tmp --nthread 40 --statoff  --readLength 255 --variable-read-length
  else
    echo "$file already indexed"
  fi
done

