#!/bin/bash

db=../data/Csec.fa
bed=../data/prdm9.bed
out=../data/prdm9.fna

bedtools getfasta -fi $db -bed $bed -fo $out
