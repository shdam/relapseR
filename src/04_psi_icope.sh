#!/bin/bash

# Define variables
OUTPUT_DIR="rMATS_output"
PSI_FILE="$OUTPUT_DIR/SE.MATS.JC.txt"
CD19_EXON2="CD19_exon2"

# Extract PSI for CD19 exon 2
grep "$CD19_EXON2" $PSI_FILE > "$OUTPUT_DIR/CD19_exon2_PSI.txt"

