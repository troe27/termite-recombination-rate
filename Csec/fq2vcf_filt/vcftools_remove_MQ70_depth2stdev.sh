#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 00:50:00
#SBATCH -J vcftools_filt_MQdepth_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# add modules 
module load bioinfo-tools
module load vcftools

cd "/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8/vcf_final_filt"

#vcf="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf"

#vcftools --vcf $vcf --exclude-bed "Csec_w100kb_rho_bpen1_filt_minMQval_70_depth_2stdev_all_scaff_invert_bed_v2.txt" --recode --out $vcf"_MQ70_depth2stdev"

vcf2="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_MQ70_depth2stdev.recode.vcf"

vcftools --vcf $vcf2 --window-pi 1000 --out $vcf2"_w1kb"
vcftools --vcf $vcf2 --window-pi 10000 --out $vcf2"_w10kb"
vcftools --vcf $vcf2 --window-pi 100000 --out $vcf2"_w100kb"

