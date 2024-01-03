#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 12
#SBATCH -t 30:00:00
#SBATCH -J bwa_mapping_CS_8
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se


# Main directories as variables
# SEQDIR assumed to contain all fastq-files

# Output:       Sorted, indexed BAM-file for each sample
#               BAM-stats for all samples written to the same file (bamtools_stats.txt in SEQDIR)

# Update this with the full path to the directory where you have the sample fastq files
SEQDIR="/proj/snic2021-23-365/delivery05008_termites/INBOX/P21371/P21371_118/02-FASTQ/210824_A00689_0330_BHGMKYDSX2"

# Reference sequence
# Update this with the full path to the directory where you have the reference genome
REFDIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec"
# Update this with the name of the ref fasta file
REF=$REFDIR/Csec.fna

map_reads () {

        # Load the bwa module to make bwa available
        # Load samtools, bamtools

        module load bioinfo-tools
        module load bwa
        module load samtools
        module load bamtools

        # Enter directory with data...

        cd $SEQDIR/

        # Create file for bamtools stats
        STAT_FILE="/proj/snic2021-23-365/private/termite_analysis/Csec/bamtools_stats_CS_8.txt"
        >$STAT_FILE

        for SAMPLE in `ls *_R1_001.fastq.gz | sed s/"_R1_001.fastq.gz"/""/g`; do #list all the sample names without the file extensions

                                        echo "MAPPING $SAMPLE ..."

                                        # Run bwa across all allocated cores with the new mem
                                        # algorithm, and pipe the output to samtools to make a
                                        # sorted BAM file

                                        time bwa mem -t 12 $REF \
                                                ${SAMPLE}"_R1_001.fastq.gz" \
                                                ${SAMPLE}"_R2_001.fastq.gz" \
                                                2> ${SAMPLE}.bam.bwa.log \
                                                | samtools view -b | samtools sort -o ${SAMPLE}.sorted.bam -O BAM

                                        # Index the BAM file

                                        samtools index ${SAMPLE}.sorted.bam

                                # If sorted BAM-file was created in previous step, or existed from before: extract the bamstats and append to file
                                if [ -e ${SAMPLE}.sorted.bam ]; then

                                        echo "Running bamtools stats for ${SAMPLE}.sorted.bam"
                                        echo "${SAMPLE}" >> $STAT_FILE
                                        bamtools stats -in ${SAMPLE}.sorted.bam >> $STAT_FILE

                                else

                                        echo "BAM-file ${SAMPLE}.sorted.bam not found. No stats produced."

                                fi


        done

}

# Run the function map_reads above by uncommenting and execute the script

map_reads
