#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J bwa_index
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# sequence dir
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names"
#Reference 
REF=$SEQDIR/New_Mbel.fa

# add modules 
module load bioinfo-tools
module load bwa


bwa index -a bwtsw $REF
