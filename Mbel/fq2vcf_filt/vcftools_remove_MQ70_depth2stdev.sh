#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 00:20:00
#SBATCH -J vcftools_filt_MQdepth_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# add modules 
module load bioinfo-tools
module load vcftools

cd "/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs/vcf_final_filt"

#vcf="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf"
#vcf="temp.vcf"

#vcftools --vcf $vcf --exclude-bed "Mbel_w100kb_rho_bpen1_filt_minMQval_70_depth_2stdev_all_scaff_100N_invert_bed_updated_wend_rm_neg_interv_v4.txt" --recode --out $vcf"_MQ70_depth2stdev_v4"
#--exclude-bed "Mbel_w100kb_rho_bpen1_filt_minMQval_70_depth_2stdev_all_scaff_100N_invert_bed_updated_wend_subset.txt"

vcf2="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_MQ70_depth2stdev_v4.recode.vcf"

vcftools --vcf $vcf2 --window-pi 1000 --out $vcf2"_w1kb"
vcftools --vcf $vcf2 --window-pi 10000 --out $vcf2"_w10kb"
vcftools --vcf $vcf2 --window-pi 100000 --out $vcf2"_w100kb"

