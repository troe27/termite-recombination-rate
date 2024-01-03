#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 240:00:00
#SBATCH -J read_depth_MAPQ
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools
module load samtools

BAM_DIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec"

OUT_DIR="/proj/snic2021-23-365/private/termite_analysis/Csec"

cd $BAM_DIR

samtools mpileup --output-extra MAPQ -a -o $OUT_DIR/CS_sorted_marked_dupes_rg_mpileup.txt CS_1.sorted.marked_dupes.rg.bam CS_2.sorted.marked_dupes.rg.bam CS_3.sorted.marked_dupes.rg.bam CS_4.sorted.marked_dupes.rg.bam CS_5.sorted.marked_dupes.rg.bam CS_6.sorted.marked_dupes.rg.bam CS_7.sorted.marked_dupes.rg.bam CS_9.sorted.marked_dupes.rg.bam CS_10.sorted.marked_dupes.rg.bam


