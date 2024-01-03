#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J gatk_hard_filt_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Path to where you have the vcf-files
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/vcfs_wout_CS8"

# Reference sequence
# Path and file name for ref genome
REFDIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec"
REF=$REFDIR"/Csec.fna"

function filter_variants() {

	module load bioinfo-tools
	module load GATK

	cd $SEQDIR

	vcf="Csec_concat_geq1000_no_indels.recode.vcf"

		#updated filter limits based on stats for Csec
		#need to specify limits with decimal point, e.g. 3.0 and not just 3	
#		gatk VariantFiltration \
#			-R $REF \
#			-V $vcf \
#	    		-O ${vcf}.hard.filtered.vcf \
#	    		--filter-name "QD" \
#			--filter-expression "QD < 2.0" \
#	    		--filter-name "FS" \
#	    		--filter-expression "FS > 50.0" \
#	    		--filter-name "MQ" \
#	    		--filter-expression "MQ < 40.0" \
#	    		--filter-name "MQRankSum" \
#	    		--filter-expression "MQRankSum < -5.0" \
#	    		--filter-name "MQRankSum_high" \
#	    		--filter-expression "MQRankSum > 5.0" \
#	    		--filter-name "ReadPosRankSum" \
#	    		--filter-expression "ReadPosRankSum < -4.0" \
#	    		--filter-name "ReadPosRankSum_high" \
#	    		--filter-expression "ReadPosRankSum > 4.0" \
#			--filter-name "SOR" \
#			--filter-expression "SOR > 3.0"

	vcf2=$vcf".hard.filtered.vcf"
	vcf2_out="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf"

	gatk VariantFiltration \
		-R $REF \
		-V $vcf2 \
	    	-O $vcf2_out \
	    	--filter-name "ExcessHet" \
		--filter-expression "ExcessHet > 5.0"

}

filter_variants











