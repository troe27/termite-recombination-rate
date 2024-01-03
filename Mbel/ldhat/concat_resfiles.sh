#!/bin/bash

cd interval_output_bpen1

#CONCAT0="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen20_statres.txt"
#CONCAT10="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen20_statres.txt_w10kb"
#CONCAT1="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen20_statres.txt_w1kb"

#CONCAT100="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres.txt_w100kb"
#CONCAT50="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres.txt_w50kb"

CONCAT500="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres.txt_w500kb"

#printf "Scaffold\tLoci_kb\tMean_rho\tMedian\tL95\tU95\n" > $CONCAT0
#printf "Scaffold\tWind_start\tWind_end\tMean_rho\n" > $CONCAT10
#printf "Scaffold\tWind_start\tWind_end\tMean_rho\n" > $CONCAT1

#printf "Scaffold\tWind_start\tWind_end\tMean_rho\n" > $CONCAT100
#printf "Scaffold\tWind_start\tWind_end\tMean_rho\n" > $CONCAT50

printf "Scaffold\tWind_start\tWind_end\tMean_rho\n" > $CONCAT500

for scaffold in `ls Mbel_*_statres.txt | sed s/"Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_"/""/g | sed s/"_LDhat_bpen1_statres.txt"/""/g | sort -V`; do
	resfile="Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_"$scaffold"_LDhat_bpen1_statres.txt"
	#cat $resfile | tail -n +3 | awk -v scaff=$scaffold '{ print scaff"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5 }' >> $CONCAT0
	#cat $resfile"_w10kb" | awk -v scaff=$scaffold '{ print scaff"\t"$0 }' >> $CONCAT10
	#cat $resfile"_w1kb" | awk -v scaff=$scaffold '{ print scaff"\t"$0 }' >> $CONCAT1

	#cat $resfile"_w100kb" | awk -v scaff=$scaffold '{ print scaff"\t"$0 }' >> $CONCAT100
	#cat $resfile"_w50kb" | awk -v scaff=$scaffold '{ print scaff"\t"$0 }' >> $CONCAT50

	cat $resfile"_w500kb" | awk -v scaff=$scaffold '{ print scaff"\t"$0 }' >> $CONCAT500
done

