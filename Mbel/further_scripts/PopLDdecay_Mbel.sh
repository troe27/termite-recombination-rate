#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:30:00
#SBATCH -J PopLDdecay_Mbel
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# module load bioinfo-tools
# module load vcftools

/proj/snic2021-23-365/nobackup/tuuli/termites/PopLDdecay/PopLDdecay/bin/PopLDdecay -InVCF /proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs/vcf_final_filt/Mbel_concat_excl5scaff_rmind_hfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_v4.vcf_scaff_breaks_at_100N \
				-MaxDist 10 \
                                -OutStat /proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/PopLDdecay/Mbel_concat_excl5scaff_rmind_hfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_v4.vcf_scaff_breaks_at_100N_poplddecay
 
# -SubPop Group4.list
