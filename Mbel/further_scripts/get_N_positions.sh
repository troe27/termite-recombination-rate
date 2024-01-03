# Fasta-file has no newlines except between scaffolds
# N:s in the sequence only exist in consecutive stretches of 100 Ns (checked this previously)

cat New_Mbel.fa | awk -F "" '{ if ($1 == ">") { printf "\n"$0"\n" } else { printf "N\t"; for (i=1; i<=NF; i++) { if ($i=="N" || $i=="n") { printf i"\t" } }  } }' > New_Mbel_pos_of_Ns.txt

cat New_Mbel_pos_of_Ns.txt | awk -F "\t" '{ if ($1 != "N") {printf "\n"$0"\n"} else { for (i=2;i<=NF;i+=100) { for (j=0;j<=99;j++) { printf $(i+j)"\t" } printf "\n" } } }' > New_Mbel_pos_of_Ns_2.txt

cat New_Mbel_pos_of_Ns_2.txt | awk '{ if (NF>3) { print $1"\t"$NF } else if (NF > 0) {print $1} }' > New_Mbel_pos_of_Ns_3.txt

cat New_Mbel_pos_of_Ns_3.txt | grep -v ">" | awk '{ print $2-$1 }' > sanity_check.txt

cat New_Mbel_pos_of_Ns_3.txt | awk -F "" '{ if ($1==">") { scaff=$0 } else { print scaff"\t"$0 } }' > New_Mbel_pos_of_Ns_4.txt

cat New_Mbel_pos_of_Ns_4.txt | sed s/">"/""/g > New_Mbel_pos_of_Ns_5.txt

cd LDhat/input_files

printf "Scaffold\tMarker_pos_kb\n" > locs_file_concat.txt

for locs_file in `ls *.locs | sort -V`; do
	scaff=`echo $locs_file | sed s/"Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_"/""/g | sed s/"_LDhat.ldhat.locs"/""/g`
	cat $locs_file | tail -n +3 | awk -v scaff=$scaff '{ print scaff"\t"$0 }' >> locs_file_concat.txt
done

cd ../interval_output_bpen1

paste concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres.txt ../input_files/locs_file_concat.txt > concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_extra_col.txt

#use New_Mbel_pos_of_Ns_5.txt and concat_Mbel...statres_extra_col.txt in local R script to replace rho by "NA" in regions that overlap a stretch of 100 N. => concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_100N.txt

