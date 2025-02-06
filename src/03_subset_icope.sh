#!/bin/bash

echo "Subsetting alignment"
cd /home/projects/dp_immunoth/data/iCOPE
mkdir -p cd19


echo "Indexing mapped reads with samtools"
for file in mapped/*.bam; do
  if [ ! -f mapped/$(basename "$file").bai ]; then
    samtools index --threads 39 "$file" 
  else
    echo "$file already indexed"
  fi
done

for file in mapped/*.bam; do
  if [ ! -f  cd19/"$file" ]; then
    base=$(basename "$file" .bam)
    
    samtools view --write-index -b $file chr16:28931971-28939342  > cd19/$base.cd19.bam
  fi
done

