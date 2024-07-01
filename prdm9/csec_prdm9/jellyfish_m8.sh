#!/bin/bash

# total
#jellyfish bc -m 8 -s 20G -t 20 -o ../data/csec_m8.bc ../data/Csec.fa && \
jellyfish count -m 8 -s 20G -t 20 --bc ../data/csec_m8.bc ../data/Csec.fa && jellyfish dump -c ./mer_counts.jf > tot_m8.count


# total

#jellyfish bc -m 8 -s 20G -t 20 -o ../data/csec_m8_lq.bc ../data/20231018_1kb_rho_lower_quantile10.fna && \
#jellyfish count -m 8 -s 20G -t 20 --bc ../data/csec_m8_lq.bc ../data/20231018_1kb_rho_lower_quantile10.fna && jellyfish dump -c ./mer_counts.jf > lq_m8.count



#jellyfish bc -m 8 -s 20G -t 20 -o ../data/csec_m8_uq.bc ../data/20231018_1kb_rho_upper_quantile10.fna && \
#jellyfish count -m 8 -s 20G -t 20 --bc ../data/csec_m8_uq.bc ../data/20231018_1kb_rho_upper_quantile10.fna && jellyfish dump -c ./mer_counts.jf > uq_m8.count