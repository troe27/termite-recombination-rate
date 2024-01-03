#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcftools_stats_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# add modules 
module load bioinfo-tools
module load vcftools
module load bcftools
module load GATK

cd vcfs

#file_list1=`ls *_output.vcf | grep -v "scaffold93" | grep -v "scaffold62" | grep -v "scaffold41" | grep -v "scaffold35" | grep -v "scaffold32"`

#bcftools concat -O v -o Mbel_concat_excl_5_scaffolds_nofilt.vcf $file_list1 

#gatk VariantsToTable \
#	-V "Mbel_concat_excl_5_scaffolds_nofilt.vcf" \
#	-F ExcessHet \
#	-O "gatk_stats/Mbel_excl5scaf_nofilt_gatk_excess_het.table"


#file_list=`ls *.hard.filtered.vcf | grep -v "scaffold93" | grep -v "scaffold62" | grep -v "scaffold41" | grep -v "scaffold35" | grep -v "scaffold32"`

#bcftools concat -O v -o Mbel_concat_excl_5_scaffolds_hard_filtered.vcf $file_list 

#vcf="Mbel_concat_excl_5_scaffolds_hard_filtered.vcf"

#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --site-quality --out vcftools_stats_excl5scaf/$vcf
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --het --out vcftools_stats_excl5scaf/$vcf
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --indv-freq-burden --out vcftools_stats_excl5scaf/$vcf

#vcf="Mbel_concat_hard_filtered.vcf"
#pos_file="vcftools_stats/Mbel_concat_AF05_positions.txt"

#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --het --out vcftools_stats/Mbel_het_stats_concat.het

#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --positions $pos_file --freq2 --out vcftools_stats/$vcf"_AF05"
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --positions $pos_file --geno-depth --out vcftools_stats/$vcf"_AF05"
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --positions $pos_file --site-quality --out vcftools_stats/$vcf"_AF05"
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --positions $pos_file --het --out vcftools_stats/$vcf"_AF05"
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --positions $pos_file --indv-freq-burden --out vcftools_stats/$vcf"_AF05"
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --positions $pos_file --missing-site --out vcftools_stats/$vcf"_AF05"

#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --remove-filtered-all --site-mean-depth --out vcftools_stats/Mbel_rm_filt_site_mean_depth
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --remove-filtered-all --freq2 --out vcftools_stats/Mbel_rm_filt


#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --remove-filtered-all --max-meanDP 50 --min-meanDP 5 --freq2 --out vcftools_stats/Mbel_rm_hfilt_depth_filt_5_50
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --remove-filtered-all --max-meanDP 50 --min-meanDP 5 --het --out vcftools_stats/Mbel_rm_hfilt_depth_filt_5_50
#vcftools --vcf $vcf --remove-indels --min-alleles 2 --max-alleles 2 --remove-filtered-all --max-meanDP 50 --min-meanDP 5 --max-missing 1.0 --indv-freq-burden --out vcftools_stats/Mbel_rm_hfilt_depth_filt_5_50_no_missing

vcf="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf"

#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --freq2 --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --geno-depth --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --site-quality --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --het --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --indv-freq-burden --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --missing-site --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --site-mean-depth --out vcftools_stats_final/$vcf"_biallelic_rmfilt"
#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --counts2 --out vcftools_stats_final/$vcf"_biallelic_rmfilt"


vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --SNPdensity 1000 --out vcftools_stats_final/$vcf"_biallelic_rmfilt_w1kb"
vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --remove-filtered-all --SNPdensity 10000 --out vcftools_stats_final/$vcf"_biallelic_rmfilt_w10kb"


