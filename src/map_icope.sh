#!/bin/bash

echo "Aligning reads with STAR"

# Function to check if files exist
check_files() {
  for file in "$@"; do
    if [ ! -f "$file" ]; then
      return 1
    fi
  done
  return 0
}


ref_files=("ref/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa" "ref/Homo_sapiens.GRCh38.107.gtf")
if ! check_files "${ref_files[@]}"; then
  echo "Downloading reference"
  mkdir -p ref
  cd ref
  wget http://ftp.ensembl.org/pub/release-107/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
  wget http://ftp.ensembl.org/pub/release-107/gtf/homo_sapiens/Homo_sapiens.GRCh38.107.gtf.gz
  gunzip *.gz
  cd ..
fi

index_files=("ref/SAindex")
if ! check_files "${index_files[@]}"; then
  echo "Indexing genome"
  STAR --runMode genomeGenerate --genomeDir ref/ --genomeFastaFiles ref/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa --sjdbGTFfile ref/Homo_sapiens.GRCh38.107.gtf --runThreadN 8
fi

echo "Mapping reads"
mkdir -p mapped
cd trimmed
for file in *.R1.fq.gz; do
  forward="$file"
  reverse="${file%.R1.fq.gz}.R2.fq.gz"
  if [ -f "$forward" ] && [ -f "$reverse" ]; then
    base=$(basename "$forward" .R1.fq.gz)
    STAR --runMode alignReads --runThreadN 8 --genomeDir ../ref/ --outSAMtype BAM SortedByCoordinate --readFilesIn "$forward" "$reverse" --readFilesCommand gunzip -c --outFileNamePrefix ../mapped/"$base"_
  else
    echo "Warning: Missing forward or reverse file for $base"
  fi
done

cd ../mapped
mkdir -p ../bam
mv *.bam ../bam
cd ../bam

echo "Indexing mapped reads with samtools"
for file in *.bam; do
  samtools index "$file"
done
