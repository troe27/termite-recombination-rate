# input
import pandas as pd
import argparse
import numpy as np

# def function
def cli_parser():
    '''
    parses command line input
   
    '''
    parser_main = argparse.ArgumentParser(prog='getcpg_chunk.py')
    parser_main.add_argument("--input",
                             help="input_chunk from gff3 file",
                             required = True)

    args = parser_main.parse_args()
    return args


def get_weighted_CpG(ss_data, row):
  if ss_data.shape[0]==0:
    return 'no_overlap_bin'
  else:
    cpg_fracs= []
    overlaps = []
    for i, b in ss_data.iterrows():
      bin_start = (b.bin_start)
      bin_end = (b.bin_stop)
      gene_start = row.start
      gene_end = row.stop
      if bin_start < gene_start:
        if bin_end > gene_end:
          #print('all of the gene is in the bin, return cpg')
          return b.cpg_obs_exp
        else:
          # overlap is bin_end - gene_start
          overlap = bin_end - gene_start
          cpg_frac = b.cpg_obs_exp*overlap
      else:
        if bin_end > gene_end:
          overlap = gene_end - bin_start
          cpg_frac = b.cpg_obs_exp*overlap
        else:
          overlap = bin_end - bin_start
          cpg_frac = b.cpg_obs_exp*overlap
      cpg_fracs.append(cpg_frac)
      overlaps.append(overlap)
    return sum(cpg_fracs)/sum(overlaps)

# run stuff

# load data
args =cli_parser()
chunk = pd.read_csv(args.input, sep=',')
data = pd.read_csv('20230711_Csec_CpG_1kbwindow_with_start_stop_pos_and_scaffold_id.csv', sep=',')
print('loaded data')
print(data.iloc[0,])


weighted_cpg = []
for index,row in chunk.iterrows():
  ss_data = data.loc[data.scaffold==row.scaffold].loc[(data.bin_start)<row.stop].loc[(data.bin_stop)>row.start]
  cpg = get_weighted_CpG(row=row, ss_data=ss_data)
  weighted_cpg.append("\t".join([str(j) for j in row])+'\t'+str(cpg))
  if index%1e2 == 0:
    print("\t".join([str(j) for j in row])+'\t'+str(cpg))
    print(index)
    
# write output
#print(args.input)
outfile = args.input.rsplit(".")[0]+".cpg"
print(outfile)
with open(outfile, "wt") as handle:
    handle.write('\n'.join(weighted_cpg))
