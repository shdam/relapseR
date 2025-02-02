#!/bin/bash

# Define variables
GTF="ref/Homo_sapiens.GRCh38.107.gtf"
BAM_DIR="bam"
OUTPUT_DIR="rMATS_output"

# Create output directory
mkdir -p $OUTPUT_DIR

# Run rMATS
rmats.py --b1 $BAM_DIR/*.bam --gtf $GTF --od $OUTPUT_DIR --t paired --nthread 8
