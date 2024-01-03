#!/bin/bash

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 20
#SBATCH -t 03:00:00
#SBATCH -J stat_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/LDhat/interval_output_bpen20"

cd $SEQDIR

# This function is to run the jobs in parallel
function pwait() {
  while [ $(jobs -p | wc -l) -ge $1 ]; do
    sleep $2
  done
}


for bounds_file in *bounds.txt; do

	pwait 20 20s
	rates_file=`printf $bounds_file | sed s/"bounds.txt"/"rates.txt"/g`
	locs_file=`printf $bounds_file | sed s/"sites_bpen20bounds.txt"/"locs"/g`

	"/proj/snic2021-23-365/private/termite_analysis/ldhat/LDhat/stat" -input $rates_file -burn 20 -loc ../input_files/$locs_file -prefix $SEQDIR/$bounds_file"_stat" &

done
wait

