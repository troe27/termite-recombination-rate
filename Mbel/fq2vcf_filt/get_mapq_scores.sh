#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 140:00:00
#SBATCH -J mapq_test
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

module load bioinfo-tools
module load samtools

scaffold_list=`cat New_Mbel.dict | grep -v "@HD" | awk '{ print $2 }' | sed s/"SN:"/""/g`
#scaffold_list=("scaffold2" "scaffold100" "scaffold105" "scaffold110" "scaffold93" "scaffold62" "scaffold41" "scaffold35" "scaffold32")
#scaffold_list=("scaffold1" "scaffold2")
#indv_list=("MB_1" "MB_2" "MB_3" "MB_4" "MB_5" "MB_6" "MB_7" "MB_8" "MB_9" "MB_10")
indv_list=("MB_1" "MB_2")

>"mapq/mapq_mean_per_scaffold.txt"

for scaffold in ${scaffold_list[*]}; do
	for indv in ${indv_list[*]}; do
		printf "%s\t%s\t" $scaffold $indv >> "mapq/mapq_mean_per_scaffold.txt"
		samtools view $indv".sorted.marked_dupes.rg.bam" | awk '{ print $3"\t"$4"\t"$5 }' | grep -w $scaffold | awk 'BEGIN {msum=0; i=0} {msum+=$3; i+=1} END {print msum/i}' >> "mapq/mapq_mean_per_scaffold.txt"
	done
done


