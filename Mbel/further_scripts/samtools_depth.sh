#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 60:00:00
#SBATCH -J read_depth_MAPQ
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools
module load samtools

#samtools depth -a -H -o MB_read_depth_marked_dupes.rg.txt MB_1.sorted.marked_dupes.rg.bam MB_2.sorted.marked_dupes.rg.bam MB_3.sorted.marked_dupes.rg.bam MB_4.sorted.marked_dupes.rg.bam MB_5.sorted.marked_dupes.rg.bam MB_6.sorted.marked_dupes.rg.bam MB_7.sorted.marked_dupes.rg.bam MB_8.sorted.marked_dupes.rg.bam MB_9.sorted.marked_dupes.rg.bam MB_10.sorted.marked_dupes.rg.bam

samtools mpileup --output-extra MAPQ -a -o MB_marked_dupes_rg_mplieup_MAPQ_v2.txt MB_1.sorted.marked_dupes.rg.bam MB_2.sorted.marked_dupes.rg.bam MB_3.sorted.marked_dupes.rg.bam MB_4.sorted.marked_dupes.rg.bam MB_5.sorted.marked_dupes.rg.bam MB_6.sorted.marked_dupes.rg.bam MB_7.sorted.marked_dupes.rg.bam MB_8.sorted.marked_dupes.rg.bam MB_9.sorted.marked_dupes.rg.bam MB_10.sorted.marked_dupes.rg.bam


