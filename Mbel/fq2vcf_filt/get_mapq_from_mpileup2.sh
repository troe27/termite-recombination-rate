#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J extract_from_mpileup
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se


#cat MB_marked_dupes_rg_mplieup.txt | awk '{ print $1"\t"$2"\t"$7"\t"$11"\t"$15"\t"$19"\t"$23"\t"$27"\t"$31"\t"$35"\t"$39"\t"$43 }' > MB_marked_dupes_rg_mpileup_MQ.txt

#cat MB_marked_dupes_rg_mpileup_MQ.txt | awk '{ print $3$4$5$6$7$8$9$10$11$12 }' > MB_marked_dupes_rg_mpileup_MQonly.txt

#cat MB_marked_dupes_rg_mpileup_MQonly.txt | awk -F "" 'BEGIN {for(n=0;n<256;n++)ord[sprintf("%c",n)]=n} {sum_=0; for (i=1;i<=NF;i++) { sum_+=ord[$i] } print sum_/NF }' > MB_marked_dupes_rg_mpileup_MQmean.txt

#cat MB_marked_dupes_rg_mpileup_MQ.txt | awk '{num_missing=0; for (i=3;i<=NF;i++) {if ($i=="*") num_missing+=1}; print $1"\t"$2"\t"num_missing }' > MB_marked_dupes_rg_mpileup_MQ_missingdata.txt

#cat MB_marked_dupes_rg_mpileup_MQonly.txt | awk -F "" '{ print NF }' > MB_marked_dupes_rg_mpileup_numvals.txt

#paste MB_marked_dupes_rg_mpileup_MQ_missingdata.txt MB_marked_dupes_rg_mpileup_numvals.txt MB_marked_dupes_rg_mpileup_MQmean.txt > mpileup_chr_pos_missing_numvals_meanMQ.txt

# Counting one MQ-value (*=42) for each indv with missing data (no reads)
# Removing those values from the mean MQ values:

cat mpileup_chr_pos_missing_numvals_meanMQ.txt | awk '{ if ($3>0) { if ($3<$4) {mq=(($5*$4)-($3*42))/($4-$3)} else {mq=33}; print $1"\t"$2"\t"$3"\t"$4"\t"mq } else {print $0} }' > MB_marked_dupes_rg_mpileup_MQ_final.txt 

