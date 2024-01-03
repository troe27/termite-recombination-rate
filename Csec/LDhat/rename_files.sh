#!/bin/bash -l

cd interval_output_bpen1

for long_name in *_statres.txt; do
	scaffold=`echo $long_name | sed s/"Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_"/""/g | sed s/"_LDhat.ldhat.sites_bpen1bounds.txt_statres.txt"/""/g`
	mv $long_name "Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_"$scaffold"_LDhat_bpen1_statres.txt"
done

