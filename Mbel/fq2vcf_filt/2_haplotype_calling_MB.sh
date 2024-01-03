#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 20
#SBATCH -t 02:00:00
#SBATCH -J haplotype_caller_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Update to location of your bam-files
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel"
OUTDIR=$SEQDIR"/gvcfs"

# This file is created to be used in the next step
SAMP_NAME_MAP=$SEQDIR"/samp_name_map.txt"
> $SAMP_NAME_MAP

# Update with the path to your ref genome
REFDIR="/proj/snic2021-23-365/nobackup/tuuli/termites/M_bel/New_ref_Mbel"
REF=$REFDIR"/New_Mbel_midified_contig_name.fa"

# Haploid or diploid genotyping?
PLOIDY=2


# This function is to run the jobs in parallel
function pwait() {
  while [ $(jobs -p | wc -l) -ge $1 ]; do
    sleep $2
  done
}

function call_variants() {

	module load bioinfo-tools
	module load GATK #Need to use GATK4 for GenomicsDBImport

	cd $SEQDIR

	for sample in `ls MB_*.sorted.marked_dupes.rg.bam | sed s/".sorted.marked_dupes.rg.bam"/""/g`; do
		# The jobs are submitted in the background (with the "&" option below)
		# The pwait function prevents jobs from being submitted if the max number of jobs (20) are already running
		# Then it waits for 20 s and then checks again
		pwait 20 20s

		echo "Running HaplotypeCaller for $sample"

		gatk HaplotypeCaller \
		-R $REF \
		-I $sample".sorted.marked_dupes.rg.bam" \
		-O $OUTDIR/$sample".sorted.marked_dupes.rg.g.vcf.gz" \
		-ERC GVCF \
		-ploidy $PLOIDY &

		# list the sample names and directories in the samp_name_map - file
		printf "$sample\t$OUTDIR/$sample.sorted.marked_dupes.rg.g.vcf.gz\n" >> $SAMP_NAME_MAP
    
	done
	wait # wait until all jobs have finished

}

call_variants



