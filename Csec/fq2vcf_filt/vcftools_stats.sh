#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcftools_stats_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# add modules 
module load bioinfo-tools
module load vcftools

cd "/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8"

vcf="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf"

	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --freq2 --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --geno-depth --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --site-quality --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --het --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --indv-freq-burden --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --missing-site --out vcftools_stats_final/$vcf"_biallelic_rmfilt"

	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --site-mean-depth --out vcftools_stats_final/$vcf"_biallelic_rmfilt"

	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --counts2 --out vcftools_stats_final/$vcf"_biallelic_rmfilt"

