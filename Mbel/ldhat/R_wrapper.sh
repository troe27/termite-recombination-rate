#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 200:00:00
#SBATCH -J calc_rho_by_annotation
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load R_packages/4.1.1
Rscript --vanilla "/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/LDhat/rho_for_annotation/calc_rho_per_exon.R"


