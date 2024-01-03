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

DATA_DIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs/pca"

cd $DATA_DIR

in_file="Mbel_concat_excl_5_scaffolds_hard_filtered.vcf_plink"
out_file=$in_file"_pca"

plink --file $in_file --allow-extra-chr --pca tabs --out $out_file


