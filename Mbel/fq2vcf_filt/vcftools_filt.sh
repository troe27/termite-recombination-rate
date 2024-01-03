#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcftools_filt_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# add modules 
module load bioinfo-tools
module load vcftools

cd "/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs"

vcf="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --mac 2 --max-missing 0.6 --remove-filtered-all --recode --out vcf_final_filt/$vcf"_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --remove-filtered-all --window-pi 10000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w10kb"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --remove-filtered-all --TajimaD 10000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w10kb"



	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --remove-filtered-all --window-pi 1000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w1kb"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --remove-filtered-all --TajimaD 1000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w1kb"


	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --remove-filtered-all --window-pi 100000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w100kb"

	#vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --remove-filtered-all --TajimaD 100000 --out vcf_pi_Tajima/$vcf"_biallelic_dpfilt_qualfilt_no_mac_filt_maxmiss06_rmfilt_w100kb"




	vcftools --vcf $vcf --min-alleles 2 --max-alleles 2 --min-meanDP 5 --max-meanDP 40 --minQ 30 --max-missing 0.6 --exclude-bed "vcf_final_filt/Mbel_w100kb_rho_bpen1_filt_minMQval_70_depth_2stdev_all_scaff_100N_invert_bed_updated_wend_rm_neg_interv_v4.txt" --remove-filtered-all --recode --out vcf_final_filt/$vcf"_biallelic_dpfilt_qualfilt_no_mac_maxmiss06_rmfilt_MQ70_dp2stdev"


