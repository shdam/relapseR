#!/bin/bash

echo "Trimming reads"
#alias fastp='/home/ctools/fastp/fastp'
cd /home/projects/dp_immunoth/data/iCOPE
mkdir -p trimmed
# ./*
for subfolder in ./RNAseq/11021_000001.T.T02.S2; do
  if [ -d "$subfolder" ]; then
    # Find the forward and reverse files
    forward=$(find "$subfolder" -type f -name "*.R1.fq.gz")
    reverse=$(find "$subfolder" -type f -name "*.R2.fq.gz")

    # Check if both files are found
    if [ -n "$forward" ] && [ -n "$reverse" ]; then
      # Define the output paths
      trimmed_forward="trimmed/$(basename "$forward")"
      trimmed_reverse="trimmed/$(basename "$reverse")"

      # Run fastp
      fastp -i "$forward" -I "$reverse" -o "$trimmed_forward" -O "$trimmed_reverse" --detect_adapter_for_pe -c --cut_front --cut_right
    else
      echo "Warning: Missing forward or reverse file in $subfolder" >> log/out
    fi
  fi
done
