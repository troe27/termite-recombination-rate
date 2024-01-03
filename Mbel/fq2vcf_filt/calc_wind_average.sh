#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 120:00:00
#SBATCH -J wind_averages
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se


RD_file="MB_read_depth_marked_dupes.rg_means.txt"
scaff_list=`cat $RD_file | tail -n +2 | awk '{ print $1 }' | sort -V | uniq`

#RD_out="MB_read_depth_marked_dupes.rg_means_w100kb.txt"
#wsize=100000

#printf "CHROM\tEND_POS\tMean_depth\n" > $RD_out

#for scaffold in ${scaff_list[*]}; do
#	cat $RD_file | grep -w $scaffold > temp_RD_file.txt
#	echo $scaffold
#	nrows=`cat "temp_RD_file.txt" | wc -l`
#	echo "nrows:"
#	echo $nrows
#	for i in `seq 1 $wsize $nrows`; do
#		echo "i:"
#		echo $i
#		cat temp_RD_file.txt | tail -n +$i | head -n $wsize | awk 'BEGIN {RD=0} { RD+=$3 } END { print $1"\t"$2"\t"RD/NR }' >> $RD_out	
#	done
#done


#RD_out="MB_read_depth_marked_dupes.rg_means_w50kb.txt"
#wsize=50000

#printf "CHROM\tEND_POS\tMean_depth\n" > $RD_out

#for scaffold in ${scaff_list[*]}; do
#	cat $RD_file | grep -w $scaffold > temp_RD_file.txt
#	echo $scaffold
#	nrows=`cat "temp_RD_file.txt" | wc -l`
#	echo "nrows:"
#	echo $nrows
#	for i in `seq 1 $wsize $nrows`; do
#		echo "i:"
#		echo $i
#		cat temp_RD_file.txt | tail -n +$i | head -n $wsize | awk 'BEGIN {RD=0} { RD+=$3 } END { print $1"\t"$2"\t"RD/NR }' >> $RD_out	
#	done
#done


RD_out="MB_read_depth_marked_dupes.rg_means_w1kb.txt"
wsize=1000

printf "CHROM\tEND_POS\tMean_depth\n" > $RD_out

for scaffold in ${scaff_list[*]}; do
	cat $RD_file | grep -w $scaffold > temp_RD_file.txt
	echo $scaffold
	nrows=`cat "temp_RD_file.txt" | wc -l`
	echo "nrows:"
	echo $nrows
	for i in `seq 1 $wsize $nrows`; do
		echo "i:"
		echo $i
		cat temp_RD_file.txt | tail -n +$i | head -n $wsize | awk 'BEGIN {RD=0} { RD+=$3 } END { print $1"\t"$2"\t"RD/NR }' >> $RD_out	
	done
done

