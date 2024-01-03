#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:30:00
#SBATCH -J PopLDdecay_Csec
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# module load bioinfo-tools
# module load vcftools

/proj/snic2021-23-365/nobackup/tuuli/termites/PopLDdecay/PopLDdecay/bin/PopLDdecay -InVCF /proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8/vcf_final_filt/Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_MQ70_depth2stdev.recode.vcf \
				-MaxDist 10 \
                                -OutStat /proj/snic2021-23-365/private/termite_analysis/Csec/PopLDdecay/Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_MQ70_depth2stdev.recode.vcf_poplddecay_maxdist10kb
 
# -SubPop Group4.list
