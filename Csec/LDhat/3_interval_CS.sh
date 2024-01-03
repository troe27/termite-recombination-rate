#!/bin/bash

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 20
#SBATCH -t 150:00:00
#SBATCH -J interval_CS
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/LDhat/input_files"

lookup="/proj/snic2021-23-365/private/termite_analysis/Csec/LDhat/lk_n18_theta004.txt"

OUTDIR="/proj/snic2021-23-365/private/termite_analysis/Csec/LDhat/interval_output_bpen20"

cd $SEQDIR

# This function is to run the jobs in parallel
function pwait() {
  while [ $(jobs -p | wc -l) -ge $1 ]; do
    sleep $2
  done
}


for locs_file in *.locs; do

	pwait 20 20s
	sites_file=`printf $locs_file | sed s/".locs"/".sites"/g`

	"/proj/snic2021-23-365/private/termite_analysis/ldhat/LDhat/interval" -seq $sites_file -loc $locs_file -lk $lookup -its 10000000 -bpen 20 -samp 5000 -prefix $OUTDIR"/"$sites_file"_bpen20" &

done
wait

