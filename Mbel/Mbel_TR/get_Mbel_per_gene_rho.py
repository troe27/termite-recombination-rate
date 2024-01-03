# input
import pandas as pd
import argparse
import numpy as np

# def function
def cli_parser():
    '''
    parses command line input
   
    '''
    parser_main = argparse.ArgumentParser(prog='get_per_gene_cpg_chunk.py')
    parser_main.add_argument("--input",
                             help="input_chunk from gff3 file",
                             required = True)
    parser_main.add_argument("--flanksize",
                             help="size of the flanking regions upstram and downstream",
                             default=1e3)
    args = parser_main.parse_args()
    return args

import pandas as pd
import os
from Bio import SeqIO
from collections import Counter


def get_weighted_mean_rho(ss_data, start, stop):
  if ss_data.shape[0]==0:
    return 'no_overlap_bin'
  else:
    rho_fracs= []
    overlaps = []
    for i, b in ss_data.iterrows():
      bin_start = (b.Pos_kb_start*1e3)
      bin_end = (b.Pos_kb_end*1e3)
      gene_start = start
      gene_end = stop
      if bin_start < gene_start:
        if bin_end > gene_end:
          #print('all of the gene is in the bin, return rho')
          return b.Mean_rho
        else:
          # overlap is bin_end - gene_start
          overlap = bin_end - gene_start
          rho_frac = b.Mean_rho*overlap
      else:
        if bin_end > gene_end:
          overlap = gene_end - bin_start
          rho_frac = b.Mean_rho*overlap
        else:
          overlap = bin_end - bin_start
          rho_frac = b.Mean_rho*overlap
      rho_fracs.append(rho_frac)
      overlaps.append(overlap)
    return sum(rho_fracs)/sum(overlaps)


# get subsets for flank and gene
def get_rho_gene_flank(data, row, flanksize):
    
    flank_start = int(row.Start_pos-flanksize)
    if flank_start<0: # make sure we dont overshoot the scaffold boundary
        flank_start=0

    flank_stop = int(row.End_pos+flanksize)
    if flank_stop>(data.Pos_kb_end.max()*1e3): # make sure we dont overshoot the scaffold boundary
        flank_stop=data.Pos_kb_end.max()

    ss_gene = data.loc[data.Scaffold==row.scaffold].loc[(data.Pos_kb_start*1e3)<row.End_pos].loc[(data.Pos_kb_end*1e3)>row.Start_pos]
    rho_gene = get_weighted_mean_rho(ss_data=ss_gene, start=row.Start_pos,stop=row.End_pos)
    
    ss_uflank = data.loc[data.Scaffold==row.scaffold].loc[(data.Pos_kb_start*1e3)<row.Start_pos].loc[(data.Pos_kb_end*1e3)>row.Start_pos-flanksize]
    rho_uflank = get_weighted_mean_rho(ss_data=ss_uflank, start=flank_start, stop=row.Start_pos)

    ss_dflank = data.loc[data.Scaffold==row.scaffold].loc[(data.Pos_kb_start*1e3)<row.End_pos+flanksize].loc[(data.Pos_kb_end*1e3)>row.End_pos]
    rho_dflank = get_weighted_mean_rho(start=row.End_pos, stop=flank_stop ,ss_data=ss_dflank)
    return [row.scaffold, rho_gene, rho_uflank, rho_dflank, row.gene_id]


def run():
    # load data    
    args =cli_parser()
    outfile = args.input.split(".")[0]+".rho"
    print(outfile)
    chunk = pd.read_csv(args.input, sep='\t')
    data = pd.read_csv("./concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_100N_red.txt", sep='\t')
    weighted_mean_rho = [] # TODO
    for index,row in chunk.iterrows():
        rho = get_rho_gene_flank(data=data, row=row, flanksize=float(args.flanksize))
        weighted_mean_rho.append('\t'.join([str(i) for i in rho]))
    
    
    with open(outfile, "wt") as handle:
        print(outfile)
        handle.write('\n'.join(weighted_mean_rho))
    

if __name__ == "__main__":
    run()

