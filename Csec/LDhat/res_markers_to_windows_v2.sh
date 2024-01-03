#!/bin/bash -l

cd interval_output_bpen1

for resfile in Csec_*_statres.txt; do
	scaffold=`echo $resfile | sed s/"Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_"/""/g | sed s/"_LDhat_bpen1_statres.txt"/""/g`

	locsfile="Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing_ph_imp.vcf_"$scaffold"_LDhat.ldhat.locs"

	paste $resfile ../input_files/$locsfile | tail -n +3 | awk ' BEGIN {rhosum=0; X=1; k=1000; wsize=100000; wsizekb=wsize/k} \
		{ while ($1*k >= X*wsize) {print (X-1)*wsize"\t"X*wsize"\t"rhosum/wsize; rhosum=0; X+=1}\
		if ($6*k > (X-1)*wsize) {\
			while ($6*k > X*wsize){\
				if ($1>(X-1)*wsizekb) {rhosum+=$2*(X*wsizekb-$1)} else {rhosum += $2*wsizekb}\
				print (X-1)*wsize"\t"X*wsize"\t"rhosum/wsize; rhosum=0; X+=1 \
			}\
			if ($1>(X-1)*wsizekb) {rhosum += $2*($6-$1)} else {rhosum += $2*($6-((X-1)*wsizekb))}\
		}\
		}\
		END { print (X-1)*wsize"\t"$6*k"\t"rhosum/($6*k-(X-1)*wsize) } ' > $resfile"_w100kb"

done


