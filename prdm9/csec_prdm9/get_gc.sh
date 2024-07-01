

#!/bin/bash

db=../data/Csec.fa
bed=../data/20231204_Csec_5fold_peaks.bed
out=../data/20231204_Csec_hs_5fold.nuc

bedtools nuc -fi $db -bed $bed > $out


db=../data/Csec.fa
bed=../data/20231205_Csec_5fold_nopeaks.bed
out=../data/20231204_Csec_hs_5fold_background.nuc

bedtools nuc -fi $db -bed $bed > $out

db=../data/Csec.fa
bed=../data/20231204_Csec_5fold_peaks_18kss.bed
out=../data/20231204_Csec_hs_5fold_18kss.nuc

bedtools nuc -fi $db -bed $bed > $out


db=../data/Csec.fa
bed=../data/20231205_Csec_5fold_nopeaks_18kss.bed
out=../data/20231204_Csec_hs_5fold_background_18kss.nuc

bedtools nuc -fi $db -bed $bed > $out
