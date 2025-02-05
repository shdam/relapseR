#!/bin/bash

echo "Aligning reads with STAR"
cd /home/projects/dp_immunoth/data/iCOPE
mkdir -p mapped

# Function to check if files exist
check_files() {
  for file in "$@"; do
    if [ ! -f "$file" ]; then
      return 1
    fi
  done
  return 0
}


ref_files=("../homo_sapiens/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa" "../homo_sapiens/Homo_sapiens.GRCh38.107.gtf")
if ! check_files "${ref_files[@]}"; then
  echo "Downloading reference"
  mkdir -p ../homo_sapiens
  cd ../homo_sapiens
  wget http://ftp.ensembl.org/pub/release-107/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
  wget http://ftp.ensembl.org/pub/release-107/gtf/homo_sapiens/Homo_sapiens.GRCh38.107.gtf.gz
  gunzip *.gz
  cd ../iCOPE
fi

index_files=("../homo_sapiens/SAindex")
if ! check_files "${index_files[@]}"; then
  echo "Indexing genome"
  STAR --runMode genomeGenerate --genomeDir ../homo_sapiens/ --genomeFastaFiles ../homo_sapiens/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa --sjdbGTFfile ../homo_sapiens/Homo_sapiens.GRCh38.107.gtf --runThreadN 38
fi

echo "Mapping reads"

for file in trimmed/*.R1.fq.gz; do
  forward="$file"
  reverse="${file%.R1.fq.gz}.R2.fq.gz"
  if [ -f "$forward" ] && [ -f "$reverse" ]; then
    base=$(basename "$forward" .R1.fq.gz)
    
    # Check if the output files already exist
      if [ ! -f "mapped/$base_Aligned.sortedByCoord.out.bam" ] || [ ! -f "bam/$base_Aligned.sortedByCoord.out.bam" ]; then
        STAR --runMode alignReads --runThreadN 38 --genomeDir ../homo_sapiens/ --outSAMtype BAM SortedByCoordinate --readFilesIn "$forward" "$reverse" --readFilesCommand gunzip -c --outFileNamePrefix mapped/"$base"_
      else
        echo "$base already mapped"
      fi
  else
    echo "Warning: Missing forward or reverse file for $base"
  fi
done

cd mapped
mkdir -p ../bam
mv *.bam ../bam
cd ../bam

echo "Indexing mapped reads with samtools"
for file in bam/*.bam; do
  if [ ! -f "$(basename "$forward").bai" ]; then
        samtools index "$file"
      else
        echo "$file already indexed"
      fi
done
