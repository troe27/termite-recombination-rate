#!/bin/bash -l

cd interval_output_bpen1

resfile="concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_100N.txt"

wsize=100000
wsizekb=$(( $wsize / 1000 ))

cat $resfile | tail -n +2 | awk -v wsize=$wsize ' BEGIN {rhosum=0; X=1; k=1000; wsizekb=wsize/k; scaff="scaffold1"; w_start=0; w_end=wsize} \
		{ if ( $1 != scaff ) { print scaff"\t"w_start"\t"w_end"\t"rhosum/(w_end-w_start); scaff=$1; X=1; rhosum=0; w_start=0; w_end=wsize }\
		if ( $3 == "NA" ) { print scaff"\t"w_start"\t"$2*k"\t"rhosum/(($2*k)-w_start); rhosum=0; w_start=$8*k; } \
		else { \
                while ($2*k >= w_end) {print scaff"\t"w_start"\t"w_end"\t"rhosum/(w_end-w_start); rhosum=0; X+=1; w_start=(X-1)*wsize; w_end=X*wsize}\
                if ($8*k > w_start) {\
                        while ($8*k > w_end){\
                                if ($2*k>w_start) {rhosum+=$3*((w_end/k)-$2)} else {rhosum += $3*(w_end-w_start)/k}\
                                print scaff"\t"w_start"\t"w_end"\t"rhosum/(w_end-w_start); rhosum=0; X+=1; w_start=(X-1)*wsize; w_end=X*wsize \
                        }\
                        if ($2*k>w_start) {rhosum += $3*($8-$2)} else if ($8*k>w_start) {rhosum += $3*($8-(w_start/k))}\
                }\
                }\
		}\
                END { print scaff"\t"w_start"\t"$8*k"\t"rhosum/($8*k-w_start) } ' > $resfile"_w"$wsizekb"kb"


