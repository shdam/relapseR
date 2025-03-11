#!/bin/bash

# Function to display usage
# Parse command-line arguments
usage() {
  echo "Usage: \$0 -i <index> [-f]"
  exit 1
}

# Parse command-line arguments
while getopts ":i:f" opt; do
  case \${opt} in
    i )
      index=\$OPTARG
      ;;
    f )
      force_remove=true
      ;;
    \? )
      echo "Invalid option: \$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Invalid option: \$OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done
shift \$((OPTIND -1))

# Check if index is provided
if [ -z "$index" ]; then
  usage
fi

# Check if index is a valid integer
if ! [[ "$index" =~ ^[0-9]+$ ]]; then
  echo "Error: Index must be an integer."
  exit 1
fi

cd /home/projects/dp_immunoth/data/iCOPE
#mamba activate outrigger-env

GTF="../homo_sapiens/Homo_sapiens.GRCh38.107.gtf"


# Get a list of all SJ.out.tab files
files=(mapped/*SJ.out.tab)

# Check if the index is within the range of the list
if [ "$index" -lt 0 ] || [ "$index" -ge ${#files[@]} ]; then
  echo "Error: Index out of range. There are ${#files[@]} files."
  exit 1
fi

# Get the selected file
input_file=${files[$index]}

# Extract the base file name and sample name
base_file=$(basename "$input_file")
SAMPLE="${base_file%_SJ.out.tab}"
TMP_dir="tmp/$SAMPLE"


# Check if the output directory exists, create if not
output_dir="outrigger/$SAMPLE"
mkdir -p "$output_dir"

# Placeholder for the actual command you want to run
echo "Processing file: $input_file"
echo "Sample: $SAMPLE"
echo "Output directory: $output_dir"

# Remove outrigger_psi.csv if -f flag is set
if [ "$force_remove" = true ] && [ -f "$output_dir/psi/outrigger_psi.csv" ]; then
  echo "Removing existing outrigger_psi.csv file."
  rm "$output_dir/psi/outrigger_psi.csv"
fi

if [ ! -f $output_dir/psi/outrigger_psi.csv ]; then
    echo "Creating tmp dir: $TMP_dir"
    mkdir -p "$TMP_dir"
    cp -r outrigger/index $TMP_dir/
    mkdir -p $TMP_dir/junctions/
    cp outrigger/junctions/metadata.csv $TMP_dir/junctions/

    # outrigger index --bam $file --gtf $GTF -o outrigger --n-jobs 38 --resume
    outrigger index -j $input_file --gtf $GTF -o $TMP_dir --n-jobs 39 --resume
    outrigger psi -o $TMP_dir

    mv $TMP_dir/junctions $output_dir/
    mv $TMP_dir/psi $output_dir/
    rm -r $TMP_dir
    # junction:16:28932089-28932910:+
  else
    echo "$file already indexed"
  fi
