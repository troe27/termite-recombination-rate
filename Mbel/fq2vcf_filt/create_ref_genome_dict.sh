#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J create_dict
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names"

module load bioinfo-tools
module load picard/1.118


cd $SEQDIR
	
                
time java -Xmx8g -jar "/proj/snic2020-6-58/private/mattc/programs/picard.jar" CreateSequenceDictionary \
	R="New_Mbel.fa" \
	O="New_Mbel.dict"	
