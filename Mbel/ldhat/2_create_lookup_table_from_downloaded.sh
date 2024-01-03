#!/bin/bash

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J lkgen_lookup_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools

/proj/snic2021-23-365/private/termite_analysis/ldhat/LDhat/lkgen -lk "downloaded_lk_n50_t0.001" -nseq 20


