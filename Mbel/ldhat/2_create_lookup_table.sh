#!/bin/bash

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J create_lookup_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

"/proj/snic2021-23-365/private/termite_analysis/ldhat/LDhat/complete" -n 20 -rhomax 100 -n_pts 101 -theta 0.001337296


