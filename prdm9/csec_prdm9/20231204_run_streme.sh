#!/bin/bash

# Set paths and parameters
input_file="../data/20231204_Csec_hs_5fold.fa"
output_directory="../data/streme_out"
background_file="../data/Csec.fa"
streme_executable="streme"

# Run STREME
$streme_executable -p $input_file -oc $output_directory --n $background_file

# Print a message indicating the completion of the analysis
echo "STREME analysis completed. Results are in: $output_directory"