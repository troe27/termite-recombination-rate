#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 12
#SBATCH -t 150:00:00
#SBATCH -J haplotype_caller_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

set -e

# Main directories as variables

# Update the location of your bam-files
SEQDIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec"
OUTDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/gvcfs_wout_CS8"

# This file is created to be used in the next step
SAMP_NAME_MAP="/proj/snic2021-23-365/private/termite_analysis/Csec/samp_name_map_wout_CS8.txt"
> $SAMP_NAME_MAP

# Update with the path to your ref genome
REFDIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec"
REF=$REFDIR/Csec.fna

# Haploid or diploid genotyping=
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

        samp_list=("CS_7" "CS_9" "CS_10")

        for sample in ${samp_list[*]}; do
                # The jobs are submitted in the background (with the "&" option below)
                # The pwait function prevents jobs from being submitted if the maximum number of jobs (10) are already running
                # Then it waits for 20 s and then checks again
                pwait 3 20s


                echo "Running HaplotypeCaller for $sample"

                gatk HaplotypeCaller \
                -R $REF \
                -I $sample".sorted.marked_dupes.rg.bam" \
                -O $OUTDIR/$sample".sorted.marked_dupes.rg.g.vcf.gz" \
                -ERC GVCF \
                -ploidy $PLOIDY &

                # List the sample names and directories in the samp_name_map -file
                printf "%s\t%s/%s.sorted.marked_dupes.rg.g.vcf.gz\n" $sample $OUTDIR $sample >> $SAMP_NAME_MAP

        done
        wait # wait until all jobs have finished

}

call_variants
