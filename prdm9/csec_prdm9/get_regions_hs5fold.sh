#!/bin/bash

#db=../data/Csec.fa
#bed=../data/20231204_Csec_5fold_peaks.bed
#out=../data/20231204_Csec_hs_5fold.fa

#bedtools getfasta -fi $db -bed $bed -fo $out


db=../data/Csec.fa
bed=../data/20231205_Csec_5fold_nopeaks.bed
out=../data/20231204_Csec_hs_5fold_background.fa

bedtools getfasta -fi $db -bed $bed -fo $out
