

#!/bin/bash

#db=../data/New_Mbel.fa
#bed=../data/20231204_Mbel_5fold_peaks.bed
#out=../data/20231204_Mbel_hs_5fold.nuc

#bedtools nuc -fi $db -bed $bed > $out


#db=../data/New_Mbel.fa
#bed=../data/20231205_Mbel_5fold_nopeaks.bed
#out=../data/20231204_Mbel_hs_5fold_background.nuc

#bedtools nuc -fi $db -bed $bed > $out

db=../data/New_Mbel.fa
bed=../data/20231204_Mbel_5fold_peaks_13kss.bed
out=../data/20231204_Mbel_hs_5fold_13kss.nuc

bedtools nuc -fi $db -bed $bed > $out


db=../data/New_Mbel.fa
bed=../data/20231205_Mbel_5fold_nopeaks_13kss.bed
out=../data/20231204_Mbel_hs_5fold_background_13kss.nuc

bedtools nuc -fi $db -bed $bed > $out
