#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J plink_recode
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools
module load plink

DATA_DIR="/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8"
OUTDIR=$DATA_DIR"/pca"
cd $DATA_DIR

in_file="Csec_concat_geq1000_no_indels.recode.vcf.hard.filtered.vcf"
out_file=$OUTDIR"/"$in_file"_plink"

plink --vcf $in_file --allow-extra-chr --const-fid --vcf-half-call m --recode --out $out_file


