#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcftools_filt_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# add modules 
module load bioinfo-tools
module load vcftools

cd "/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8"

vcf="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --mac 2 --max-missing 0.6 --remove-filtered-all --recode --out vcf_final_filt/$vcf"_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --remove-filtered-all --window-pi 10000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w10kb"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --remove-filtered-all --TajimaD 10000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w10kb"



	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --remove-filtered-all --window-pi 1000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w1kb"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --remove-filtered-all --TajimaD 1000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w1kb"


	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --remove-filtered-all --window-pi 100000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w100kb"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --remove-filtered-all --TajimaD 100000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w100kb"


	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 10 --max-meanDP 34 --minQ 30 --max-missing 0.6 --exclude-bed "vcf_final_filt/Csec_w100kb_rho_bpen1_filt_minMQval_70_depth_2stdev_all_scaff_invert_bed_v2.txt" --remove-filtered-all --recode --out vcf_final_filt/$vcf"_biallelic_dpfilt_qualfilt_no_mac_maxmiss06_rmfilt_MQ70_dp2stdev"


