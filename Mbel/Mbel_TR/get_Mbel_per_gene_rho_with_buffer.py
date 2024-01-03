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
                             default=50000)
    parser_main.add_argument("--flankbuffer",
                             help="size of the flanking buffer regions upstream and downstream",
                             default=10000)
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
      bin_start = (b.Start_pos_kb*1e3)
      bin_end = (b.End_pos_kb*1e3)
      gene_start = start
      gene_end = stop
      if bin_start < gene_start:
        if bin_end > gene_end:
          #print('all of the gene is in the bin, return rho')
          return b.Rho_per_kb
        else:
          # overlap is bin_end - gene_start
          overlap = bin_end - gene_start
          rho_frac = b.Rho_per_kb*overlap
      else:
        if bin_end > gene_end:
          overlap = gene_end - bin_start
          rho_frac = b.Rho_per_kb*overlap
        else:
          overlap = bin_end - bin_start
          rho_frac = b.Rho_per_kb*overlap
      rho_fracs.append(rho_frac)
      overlaps.append(overlap)
    return sum(rho_fracs)/sum(overlaps)


# get subsets for flank and gene
def get_rho_gene_flank(data, row, flanksize, buffer):
    
    flank_start = int(row.Start_pos-(flanksize+buffer))
    if flank_start<0: # make sure we dont overshoot the scaffold boundary
        flank_start=0

    flank_stop = int(row.End_pos+flanksize+buffer)
    if flank_stop>(data.End_pos_kb.max()*1e3): # make sure we dont overshoot the scaffold boundary
        flank_stop=data.End_pos_kb.max()

    ss_gene = data.loc[data.Scaffold==row.scaffold].loc[(data.Start_pos_kb*1e3)<row.End_pos].loc[(data.End_pos_kb*1e3)>row.Start_pos]
    rho_gene = get_weighted_mean_rho(ss_data=ss_gene, start=row.Start_pos,stop=row.End_pos)
    
    ss_uflank = data.loc[data.Scaffold==row.scaffold].loc[(data.Start_pos_kb*1e3)<(row.Start_pos-buffer)].loc[(data.End_pos_kb*1e3)>row.Start_pos-(flanksize+buffer)]
    rho_uflank = get_weighted_mean_rho(ss_data=ss_uflank, start=flank_start, stop=(row.Start_pos-buffer))

    ss_dflank = data.loc[data.Scaffold==row.scaffold].loc[(data.Start_pos_kb*1e3)<(row.End_pos+flanksize+buffer)].loc[(data.End_pos_kb*1e3)>row.End_pos+buffer]
    rho_dflank = get_weighted_mean_rho(start=(row.End_pos+buffer), stop=flank_stop ,ss_data=ss_dflank)
    return [row.scaffold, rho_gene, rho_uflank, rho_dflank, row.gene_id]


def run():
    # load data    
    args =cli_parser()
    outfile = args.input.rsplit(".")[0] +"flanksize{flanksize}_buffer{buffer}.rho".format(flanksize=args.flanksize, buffer=args.flankbuffer)
    print(outfile)
    chunk = pd.read_csv(args.input, sep='\t')
    data = pd.read_csv("../ldhat/concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt_resorted", sep='\t')
    weighted_mean_rho = [] # TODO
    for index,row in chunk.iterrows():
        rho = get_rho_gene_flank(data=data, row=row, flanksize=float(args.flanksize), buffer=int(args.flankbuffer))
        weighted_mean_rho.append('\t'.join([str(i) for i in rho]))
    
    
    with open(outfile, "wt") as handle:
        print(outfile)
        handle.write('\n'.join(weighted_mean_rho))
    

if __name__ == "__main__":
    run()

