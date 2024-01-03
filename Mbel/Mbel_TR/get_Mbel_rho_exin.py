# input
import pandas as pd
import argparse
import numpy as np

# def function
def cli_parser():
    '''
    parses command line input
   
    '''
    parser_main = argparse.ArgumentParser(prog='run_rho_chunk.py')
    parser_main.add_argument("--input",
                             help="input_chunk from gff3 file",
                             required = True)

    args = parser_main.parse_args()
    return args

def get_weighted_mean_rho(ss_data, row):
  if ss_data.shape[0]==0:
    return 'no_overlap_bin'
  else:
    rho_fracs= []
    overlaps = []
    for i, b in ss_data.iterrows():
      bin_start = (b.Pos_kb_start*1e3)
      bin_end = (b.Pos_kb_end*1e3)
      gene_start = row.Start_pos
      gene_end = row.End_pos
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


# run stuff

# load data
args =cli_parser()
chunk = pd.read_csv(args.input, sep='\t')
data = pd.read_csv('./concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_100N_red.txt', sep='\t')


weighted_mean_rho = []
for index,row in chunk.iterrows():
  ss_data = data.loc[data.Scaffold==row.Scaffold].loc[(data.Pos_kb_start*1e3)<row.End_pos].loc[(data.Pos_kb_end*1e3)>row.Start_pos]
  rho = get_weighted_mean_rho(row=row, ss_data=ss_data)
  weighted_mean_rho.append(",".join([str(j) for j in row])+','+str(rho))
  if index%1e2 == 0:
    print(",".join([str(j) for j in row])+','+str(rho))
    print(index)
    
# write output

outfile = args.input.rstrip("gff3_chunk")+".rho"
with open(outfile, "wt") as handle:
    handle.write('\n'.join(weighted_mean_rho))
