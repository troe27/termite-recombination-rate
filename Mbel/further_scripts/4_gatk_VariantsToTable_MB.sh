#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J gatk_variantstotable
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Path to where you have the vcf-files
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs"

function filter_variants() {

	module load bioinfo-tools
	module load GATK
	module load vcftools

	cd $SEQDIR

	vcf="Mbel_concat_excl_5_scaffolds_nofilt.vcf"
	#vcftools --vcf $vcf --remove-indels --recode-INFO-all --recode --out $vcf"_no_indels"

	vcf2=$vcf"_no_indels.recode.vcf"

		gatk VariantsToTable \
			-V $vcf2 \
			-F CHROM \
			-F POS \
	    		-F QD \
	    		-F FS \
	    		-F MQ \
	    		-F MQRankSum \
	    		-F ReadPosRankSum \
			-F SOR \
			-F ExcessHet \
	    		-O "gatk_stats/"$vcf2"_gatk_stats.table_w_pos"
			

}

filter_variants











