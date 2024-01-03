#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 30:00:00
#SBATCH -J wind_averages_MQ_MB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se


RD_file="MB_marked_dupes_rg_mpileup_MQ_final.txt"
scaff_list=`cat $RD_file | awk '{ print $1 }' | sort -V | uniq`

RD_out="MB_marked_dupes_rg_mpileup_MQ_final_w100kb_v2.txt"
wsize=100000

printf "Scaffold\tStart_pos\tEnd_pos\tMean_missing_indv\tMean_num_vals_excl_missing\tMean_MQ_plus33\n" > $RD_out

for scaffold in ${scaff_list[*]}; do
	cat $RD_file | grep -w $scaffold > temp_MQ_file.txt
	echo $scaffold
	nrows=`cat "temp_MQ_file.txt" | wc -l`
	echo "nrows:"
	echo $nrows
	for i in `seq 1 $wsize $(( $nrows - 1 ))`; do
		echo "i:"
		echo $i
		cat temp_MQ_file.txt | tail -n +$i | head -n $wsize | awk 'BEGIN {nmissing=0; nvals=0; MQ=0;} {if (NR==1) {printf $1"\t"$2"\t"}; nmissing+=$3; nvals+=($4-$3); MQ+=$5} END { printf $2"\t"nmissing/NR"\t"nvals/NR"\t"MQ/NR"\n" }' >> $RD_out	
	done
done


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


#RD_out="MB_read_depth_marked_dupes.rg_means_w1kb.txt"
#wsize=1000

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

