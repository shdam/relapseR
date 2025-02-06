#!/bin/bash

echo "Subsetting alignment"
cd /home/projects/dp_immunoth/data/iCOPE
mkdir -p cd19

# Function to check if files exist
check_files() {
  for file in "$@"; do
    if [ ! -f "$file" ]; then
      return 1
    fi
  done
  return 0
}


# ref_files=("cd19/Homo_sapiens.GRCh38.CD19.fa" "cd19/Homo_sapiens.GRCh38.107.CD19.gtf")
# if ! check_files "${ref_files[@]}"; then
#   echo "Subsetting reference"
#   mkdir -p ../homo_sapiens
#   cd ../homo_sapiens
#   wget http://ftp.ensembl.org/pub/release-107/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
#   wget http://ftp.ensembl.org/pub/release-107/gtf/homo_sapiens/Homo_sapiens.GRCh38.107.gtf.gz
#   gunzip *.gz
#   cd ../iCOPE
# fi


echo "Subsetting bam files"

for file in mapped/*.bam; do
  if ! check_files cd19/"$file" ; then
    base=$(basename "$file" .bam)
    samtools view -b $file chr16:28931971-28939342 > cd19/$base.cd19.bam
  fi
done

