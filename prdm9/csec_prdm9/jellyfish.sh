#!/bin/bash

# total
#jellyfish bc -m 18 -s 20G -t 20 -o ../data/csec_m18.bc ../data/Csec.fa && \
#jellyfish count -m 18 -s 20G -t 20 --bc ../data/csec_m18.bc ../data/Csec.fa

# total

jellyfish bc -m 18 -s 20G -t 20 -o ../data/csec_m18_lq.bc ../data/20231018_1kb_rho_lower_quantile10.fna && \
jellyfish count -m 18 -s 20G -t 20 --bc ../data/csec_m18_lq.bc ../data/20231018_1kb_rho_lower_quantile10.fna && jellyfish dump -c ./mer_counts.jf > lq_m18.count



jellyfish bc -m 18 -s 20G -t 20 -o ../data/csec_m18_uq.bc ../data/20231018_1kb_rho_upper_quantile10.fna && \
jellyfish count -m 18 -s 20G -t 20 --bc ../data/csec_m18_uq.bc ../data/20231018_1kb_rho_upper_quantile10.fna && jellyfish dump -c ./mer_counts.jf > uq_m18.count