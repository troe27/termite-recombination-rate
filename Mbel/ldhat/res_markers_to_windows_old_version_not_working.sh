#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J convert_rho_to_wind
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

cd interval_output_bpen1

for resfile in *_statres.txt; do
	locsfile=`echo $resfile | sed s/"sites_bpen1bounds.txt_statres.txt"/"locs"/g`

	paste $resfile ../input_files/$locsfile | tail -n +3 | awk ' BEGIN {rhosum=0; X=1; wsize=10000; wsizekb=wsize/1000} {\
		if ($6*1000 < X*wsize) {rhosum += $2*($6-max($1,(X-1)*wsizekb))} \
		else if ($1*1000 < X*wsize ) {\
			while ($6*1000 >= X*wsize) {rhosum += $2*((X*wsizekb)-max($1,(X-1)*wsizekb)); print X*wsize"\t"rhosum/wsize; rhosum=0; X+=1}\
			 {rhosum += $2*($6-((X-1)*wsizekb)) } } \
		else {\
			{print X*wsize"\t"rhosum/wsize; rhosum=0; X+=1} \
			while ($1*1000 >= X*wsize) {print X*wsize"\tNA"; X+=1; rhosum=0}\
			{rhosum += $2*(min($6,X*wsize) - max($1,(X-1)*wsize))} }\
			}\
		END { print $6"\t"rhosum/($6-(X-1)*wsizekb) } ' > $resfile"_w10kb"

done


