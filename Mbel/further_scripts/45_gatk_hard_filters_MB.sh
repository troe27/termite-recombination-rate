#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 40:00:00
#SBATCH -J gatk_hard_filt_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Path to where you have the vcf-files
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs"

# Reference sequence
# Path and file name for ref genome
REFDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names"
REF=$REFDIR"/New_Mbel.fa"

function filter_variants() {

	module load bioinfo-tools
	module load GATK

	cd $SEQDIR
	
	vcf="Mbel_concat_excl_5_scaffolds_nofilt.vcf_no_indels.recode.vcf"
	out_file="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf"
		#updated filter limits based on ststs for M bel
		#need to specify limits with decimal point, e.g. 3.0 and not just 3	
		gatk VariantFiltration \
			-R $REF \
			-V $vcf \
	    		-O $out_file \
	    		--filter-name "QD" \
			--filter-expression "QD < 2.0" \
	    		--filter-name "FS" \
	    		--filter-expression "FS > 50.0" \
	    		--filter-name "MQ" \
	    		--filter-expression "MQ < 40.0" \
	    		--filter-name "MQRankSum" \
	    		--filter-expression "MQRankSum < -6.0" \
	    		--filter-name "MQRankSum_high" \
	    		--filter-expression "MQRankSum > 4.0" \
	    		--filter-name "ReadPosRankSum" \
	    		--filter-expression "ReadPosRankSum < -4.0" \
	    		--filter-name "ReadPosRankSum_high" \
	    		--filter-expression "ReadPosRankSum > 4.0" \
			--filter-name "SOR" \
			--filter-expression "SOR > 3.0" \
			--filter-name "ExcessHet" \
			--filter-expression "ExcessHet > 5.0"


}

filter_variants











