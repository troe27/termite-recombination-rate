#!/bin/bash -l

cd interval_output_bpen1

#resfile="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_100N.txt"
resfile="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt"

wsize=1000
wsizekb=$(( $wsize / 1000 ))
outfile=$resfile"_w"$wsizekb"kb"

printf "Scaffold\tStart_bp\tEnd_bp\tRho_kb\tseq_len_with_data_bp\n" > $outfile

cat $resfile | tail -n +2 | awk -v wsize=$wsize ' BEGIN {rhosum=0; lensum=0; X=1; k=1000; wsizekb=wsize/k; scaff="scaffold1"; w_start=0; w_end=wsize} \
		{ if ( $1 != scaff ) { if (lensum>0) {print scaff"\t"w_start"\t"w_end"\t"rhosum/(lensum)"\t"lensum*k}; scaff=$1; X=1; rhosum=0; w_start=0; w_end=wsize; lensum=0 }\
		if ( $3 == "NA" ) { if (lensum>0) {print scaff"\t"w_start"\t"$2*k"\t"rhosum/(lensum)"\t"lensum*k}; lensum=0; rhosum=0; w_start=$8*k; while (w_start>=w_end) {X+=1; w_end=X*wsize} } \
		else { \
                while ($2*k >= w_end) {if (lensum>0) {print scaff"\t"w_start"\t"w_end"\t"rhosum/(lensum)"\t"lensum*k}; rhosum=0; lensum=0; X+=1; w_start=(X-1)*wsize; w_end=X*wsize}\
                if ($8*k > w_start) {\
                        while ($8*k > w_end){\
                                if ($2*k>w_start) {rhosum+=$3*((w_end/k)-$2); lensum+=((w_end/k)-$2)} else {rhosum += $3*(w_end-w_start)/k; lensum+=(w_end-w_start)/k};\
                                if (lensum>0) {print scaff"\t"w_start"\t"w_end"\t"rhosum/(lensum)"\t"lensum*k}; rhosum=0; lensum=0; X+=1; w_start=(X-1)*wsize; w_end=X*wsize \
                        }\
                        if ($2*k>w_start) {rhosum += $3*($8-$2); lensum+=($8-$2)} else if ($8*k>w_start) {rhosum += $3*($8-(w_start/k)); lensum+=$8-(w_start/k)}\
                }\
                }\
		}\
                END { if (lensum>0) {print scaff"\t"w_start"\t"$8*k"\t"rhosum/(lensum)"\t"lensum*k} } ' >> $outfile


