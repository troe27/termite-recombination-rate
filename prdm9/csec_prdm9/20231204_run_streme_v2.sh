#!/bin/bash

# Set paths and parameters
input_file="../data/20231204_Csec_hs_5fold.fa"
output_directory="../data/streme_out_v2"
background_file="../data/20231204_Csec_hs_5fold_background.fa"
streme_executable="streme"

# Run STREME
$streme_executable -p $input_file -oc $output_directory --minw 8 --maxw 20 --n $background_file

# Print a message indicating the completion of the analysis
echo "STREME analysis completed. Results are in: $output_directory"