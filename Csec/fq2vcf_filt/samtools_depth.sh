#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 20:00:00
#SBATCH -J samtools_read_depth_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools
module load samtools

BAM_DIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec"

OUT_DIR="/proj/snic2021-23-365/private/termite_analysis/Csec"

cd $BAM_DIR

#samtools depth -a -H -o $OUT_DIR/CS_sorted_marked_dupes_rg_read_depth.txt CS_1.sorted.marked_dupes.rg.bam CS_2.sorted.marked_dupes.rg.bam CS_3.sorted.marked_dupes.rg.bam CS_4.sorted.marked_dupes.rg.bam CS_5.sorted.marked_dupes.rg.bam CS_6.sorted.marked_dupes.rg.bam CS_7.sorted.marked_dupes.rg.bam CS_9.sorted.marked_dupes.rg.bam CS_10.sorted.marked_dupes.rg.bam

cd $OUT_DIR

printf "CHROM\tPOS\tMean_depth\n" > CS_sorted_marked_dupes_rg_read_depth_means.txt

cat CS_sorted_marked_dupes_rg_read_depth.txt | tail -n +2 | awk '{ depth_sum=0; for (i=3;i<=NF;i++) {depth_sum+=$i} print $1"\t"$2"\t"(depth_sum/9) }' >> CS_sorted_marked_dupes_rg_read_depth_means.txt

