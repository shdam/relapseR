#!/bin/bash


# samtools view -c ~/mnt/cr2/data/iCOPE/mapped/11021_000001.T.T02.S2_Aligned.sortedByCoord.out.bam chr16:28931965-28939342 -T ~/mnt/cr2/data/homo_sapiens/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa


if [ ! -f "/home/data/homo_sapiens/cd19.fai" ]; then
  cd /home/projects/dp_immunoth/data/homo_sapiens/
  echo "chr16:28931965-28939342" > cd19.region
  samtools faidx Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa -r cd19.region -o cd19.fai
fi

cd /home/projects/dp_immunoth//data/iCOPE
echo "Sample,CD19Count" > cd19_counts.csv

for file in mapped/*.bam; do
  # Extract the base filename (without directory and extension)
  base_filename=$(basename "$file" _Aligned.sortedByCoord.out.bam)
  echo $base_filename

  # Count the reads mapping to the CD19 region
  cd19_count=$(samtools view -c -t ../homo_sapiens/cd19.fai --threads 38 "$file")
  echo $cd19_count
  # Append the result to the CSV file
  echo "$base_filename,$cd19_count" >> cd19_counts.csv
done
