#!/bin/bash

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J create_LDhat_input_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se


module load bioinfo-tools
module load vcftools

# initially run on 10 cores, but didn't parallellize it correctly so only used 1 core
# didn't take long time to run, so removed the parallellization steps completely afterwards

SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs/vcf_final_filt"
OUTDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/LDhat/input_files"

cd $SEQDIR

vcf="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf"

create_LDhat_input () {

	for CHR in `cat $vcf | grep -v "^#" | awk '{print $1}' | uniq`; do

		vcftools --vcf $vcf --chr $CHR --ldhat --out $OUTDIR"/"$vcf"_"$CHR"_LDhat"
	
	done

}

create_LDhat_input


