#!/bin/bash

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 20:00:00
#SBATCH -J create_LDhat_input_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se


module load bioinfo-tools
module load vcftools

SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8/vcf_final_filt"
OUTDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/LDhat/input_files_remaining_scaffolds"

cd $SEQDIR

vcf="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf"


create_LDhat_input () {

	#for CHR in `cat $vcf | grep -v "^#" | awk '{print $1}' | uniq`; do
	for CHR in `cat $OUTDIR"/remaining_scaffolds.txt"`; do

		vcftools --vcf $vcf --chr $CHR --ldhat --out $OUTDIR"/"$vcf"_"$CHR"_LDhat"
	
	done

}

create_LDhat_input


