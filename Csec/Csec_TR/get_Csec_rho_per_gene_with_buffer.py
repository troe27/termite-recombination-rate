# input
import pandas as pd
import argparse
import numpy as np

# def function
def cli_parser():
    '''
    parses command line input
   
    '''
    parser_main = argparse.ArgumentParser(prog='get_Csec_per_gene_cpg_chunk.py')
    parser_main.add_argument("--input",
                             help="input_chunk from gff3 file",
                             required = True)
    parser_main.add_argument("--flanksize",
                             help="size of the flanking regions upstram and downstream",
                             default=1e3)
    parser_main.add_argument("--flankbuffer",
                             help="size of the flanking regions upstram and downstream",
                             default=10e3)
    args = parser_main.parse_args()
    return args


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
    
    flank_start = int(row.start)-(flanksize+buffer)
    if flank_start<0: # make sure we dont overshoot the scaffold boundary
        flank_start=0

    flank_stop = int(row.stop+flanksize+buffer)
    if flank_stop>(data.End_pos_kb.max()*1e3): # make sure we dont overshoot the scaffold boundary
        flank_stop=data.End_pos_kb.max()

    ss_gene = data.loc[data.Scaffold==row.scaffold2].loc[(data.Start_pos_kb*1e3)<row.stop].loc[(data.End_pos_kb*1e3)>row.start]
    rho_gene = get_weighted_mean_rho(ss_data=ss_gene, start=row.start,stop=row.stop)
    
    ss_uflank = data.loc[data.Scaffold==row.scaffold2].loc[(data.Start_pos_kb*1e3)<(row.start-buffer)].loc[(data.End_pos_kb*1e3)>row.start-(flanksize+buffer)]
    rho_uflank = get_weighted_mean_rho(ss_data=ss_uflank, start=flank_start, stop=(row.start-buffer))

    ss_dflank = data.loc[data.Scaffold==row.scaffold2].loc[(data.Start_pos_kb*1e3)<row.stop+flanksize+buffer].loc[(data.End_pos_kb*1e3)>row.stop+buffer]
    rho_dflank = get_weighted_mean_rho(start=row.stop+buffer, stop=flank_stop ,ss_data=ss_dflank)
    return [row.scaffold2, rho_gene, rho_uflank, rho_dflank, row.idstring]



def run():
    # load data    
    args =cli_parser()
    outfile = args.input.split(".")[0]+"flanksize{flanksize}_buffer{buffer}.rho".format(flanksize=str(args.flanksize), buffer=str(args.flankbuffer))
    print(outfile)
    chunk = pd.read_csv(args.input, sep='\t')
    data = pd.read_csv('../ldhat/concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_resorted', sep='\t')
    
    
    
    weighted_mean_rho = [] # TODO
    for index,row in chunk.iterrows():
        rho = get_rho_gene_flank(data=data, row=row, flanksize=float(args.flanksize), buffer=int(args.flankbuffer))
        weighted_mean_rho.append('\t'.join([str(i) for i in rho]))
    
    
    with open(outfile, "wt") as handle:
        print(outfile)
        handle.write('\n'.join(weighted_mean_rho))
    

if __name__ == "__main__":
    run()
