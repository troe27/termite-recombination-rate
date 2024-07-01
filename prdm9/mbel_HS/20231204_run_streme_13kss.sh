#!/bin/bash

# Set paths and parameters
input_file="../data/20231204_Mbel_hs_5fold_13kss.fa"
output_directory="../data/streme_out_13kss"
background_file="../data/20231204_Mbel_hs_5fold_background_13kss.fa"
streme_executable="streme"

# Run STREME
$streme_executable -p $input_file -oc $output_directory --minw 8 --maxw 20 --n $background_file

# Print a message indicating the completion of the analysis
echo "STREME analysis completed. Results are in: $output_directory"