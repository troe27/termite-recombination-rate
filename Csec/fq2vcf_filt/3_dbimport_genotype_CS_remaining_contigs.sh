#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 9
#SBATCH -t 120:00:00
#SBATCH -J dbimport_CS_remaining
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Update this with the path to the directory where you have the sample-name-map from the previous step
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/gvcfs_wout_CS8"

# The sample-name-map that you created in the previous step (tab-separated list of each sample name followed by the full path to its .g.vcf-file. One line per sample.)
SAMP_NAME="/proj/snic2022-23-268/private/termite_analysis/Csec/samp_name_map_wout_CS8.txt"

# The path to the directory where you want to have the output files
# I'd recommend you create a separate directory for this
OUTDIR="/proj/snic2022-23-268/private/termite_analysis/Csec/db_remaining_contigs"

# Reference sequence
# Update this with the path and file name for your ref genome
REF="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec/Csec.fna"

# Haploid or diploid genotyping?
PLOIDY=2

function pwait() # This function is to run the job in parallel
{
  while [ $(jobs -p | wc -l) -ge $1 ]; do
    sleep $2
  done
}

function call_variants() {

	module load bioinfo-tools
	module load GATK #Need to use GATK4 for GenomicsDBImport

	cd $SEQDIR

	# Get all the contig (or scaffold) names from the reference genome fasta file
	#CONTIG_NAMES=$(grep '>' $REF | awk '{ print $1 }' | sed 's/>//g')
	CONTIG_NAMES=("NEVH01002540.1" "NEVH01003008.1" "NEVH01004944.1" "NEVH01005281.1" "NEVH01005885.1" "NEVH01013595.1" "NEVH01021219.1" "NEVH01023969.1" "NEVH01041185.1")


	# Create a database for each contig/scaffold
	# The following command is submitted in parallel on multiple cores
	for CHR in ${CONTIG_NAMES[*]}; do
		pwait 9 20s # set the number of cores and the wait time here
		# the number of cores must be the same as the number of cores requested above (#SBATCH -n)
		echo "Running GenomicsDBImport for contig $CHR"
		gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
		--sample-name-map $SAMP_NAME \
		--genomicsdb-workspace-path $OUTDIR/contig_${CHR} \
		--intervals ${CHR} &
	done
	wait # wait for all processes to finish


	# Use the databases for joint genotyping
	# The following command is submitted in parallel on multiple cores
#	for CHR in ${CONTIG_NAMES[*]}; do
#		pwait 16 20s # set the number of cores and the wait time here
#		# the number of cores must be the same as the number of cores requested above (#SBATCH -n)
#		echo "Running GenotypeGVCFs for contig $CHR"
#		gatk --java-options "-Xmx4g -Xms4g" GenotypeGVCFs \
#		-R $REF \
#		-V gendb://$OUTDIR/contig_${CHR} \
#		-ploidy $PLOIDY \
#		-new-qual true \
#		-O $OUTDIR/contig_${CHR}_output.vcf &
#	done
#	wait # wait for all processes to finish

}

call_variants











