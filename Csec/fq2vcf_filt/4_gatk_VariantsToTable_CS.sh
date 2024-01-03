#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 12:00:00
#SBATCH -J gatk_variantstotable
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Path to where you have the vcf-files
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8"
contigs_file="/proj/snic2021-23-365/private/termite_analysis/Csec/Csec_contigs_geq1000.txt"

function filter_variants() {

	module load bioinfo-tools
	module load GATK
	module load vcftools
	module load bcftools

	cd $SEQDIR

#	contigs=`awk '{ print "contig_"$1"_output.vcf" }' $contigs_file`

#	bcftools concat -O v -o Csec_concat_geq1000_nofilt.vcf $contigs

#	vcftools --vcf Csec_concat_geq1000_nofilt.vcf --remove-indels --recode-INFO-all --recode --out Csec_concat_geq1000_no_indels
	

		gatk VariantsToTable \
			-V Csec_concat_geq1000_no_indels.recode.vcf \
			-F CHROM \
			-F POS \
	    		-F QD \
	    		-F FS \
	    		-F MQ \
	    		-F MQRankSum \
	    		-F ReadPosRankSum \
			-F SOR \
			-F ExcessHet \
	    		-O "gatk_stats/Csec_concat_geq1000_no_indels_gatk_stats.table_w_pos"


}

filter_variants











