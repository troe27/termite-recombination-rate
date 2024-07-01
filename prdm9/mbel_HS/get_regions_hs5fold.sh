#!/bin/bash

db=../data/New_Mbel.fa
bed=../data/20231204_Mbel_5fold_peaks.bed
out=../data/20231204_Mbel_hs_5fold.fa

bedtools getfasta -fi $db -bed $bed -fo $out


db=../data/New_Mbel.fa
bed=../data/20231205_Mbel_5fold_nopeaks.bed
out=../data/20231204_Mbel_hs_5fold_background.fa

bedtools getfasta -fi $db -bed $bed -fo $out
