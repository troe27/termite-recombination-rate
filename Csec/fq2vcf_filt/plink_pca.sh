#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J plink_pca
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools
module load plink

DATA_DIR="/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8/pca"

cd $DATA_DIR

in_file="Csec_concat_geq1000_no_indels.recode.vcf.hard.filtered.vcf_plink"
out_file=$in_file"_pca"

plink --file $in_file --allow-extra-chr --pca tabs --out $out_file


