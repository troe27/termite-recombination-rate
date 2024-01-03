#!/bin/bash -l

#SBATCH -A naiss2023-22-450
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J rho_vs_genome_prop
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

cd interval_output_bpen1

#infile="concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_extra_col.txt"
infile="concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt"
outfile1=$infile"_resorted"
outfile2=$outfile1"_dist"
outfile3=$outfile2"_cum"
outfile4=$outfile3"_prop"

printf "Scaffold\tStart_pos_kb\tEnd_pos_kb\tRho_per_kb\n" > $outfile1
cat $infile | tail -n +2 | grep -v "NA" | awk '{ print $1"\t"$2"\t"$8"\t"$3 }' | sort -V -r -k 4 >> $outfile1

printf "Scaffold\tStart_pos_kb\tEnd_pos_kb\tDist_kb\tRho_per_kb\tRho\n" > $outfile2
cat $outfile1 | tail -n +2 | awk '{ print $1"\t"$2"\t"$3"\t"($3-$2)"\t"$4"\t"($4*($3-$2)) }' >> $outfile2

printf "Scaffold\tStart_pos_kb\tEnd_pos_kb\tDist_kb\tRho_per_kb\tRho\tCum_dist_kb\tCum_rho\n" > $outfile3
cat $outfile2 | tail -n +2 | awk 'BEGIN {dist_cum=0; rho_cum=0;} { dist_cum+=$4; rho_cum+=$6; print $0"\t"dist_cum"\t"rho_cum }' >> $outfile3

rho_tot=`cat $outfile3 | tail -n 1 | awk '{print $8}'`
dist_tot=`cat $outfile3 | tail -n 1 | awk '{print $7}'`

printf "Scaffold\tStart_pos_kb\tEnd_pos_kb\tDist_kb\tRho_per_kb\tRho\tCum_dist_kb\tCum_rho\tCum_dist_prop\tCum_rho_prop\n" > $outfile4

cat $outfile3 | tail -n +2 | awk -v dist_tot=$dist_tot -v rho_tot=$rho_tot '{ print $0"\t"($7/dist_tot)"\t"($8/rho_tot) }' >> $outfile4

