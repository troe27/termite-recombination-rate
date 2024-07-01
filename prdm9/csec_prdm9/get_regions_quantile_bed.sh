#!/bin/bash

db=../data/Csec.fa
bed=../data/20231018_1kb_rho_lower_quantile10.bed
out=../data/20231018_1kb_rho_lower_quantile10.fna

bedtools getfasta -fi $db -bed $bed -fo $out



db=../data/Csec.fa
bed=../data/20231018_1kb_rho_upper_quantile10.bed
out=../data/20231018_1kb_rho_upper_quantile10.fna

bedtools getfasta -fi $db -bed $bed -fo $out
