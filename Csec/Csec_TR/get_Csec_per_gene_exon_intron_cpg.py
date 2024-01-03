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
    args = parser_main.parse_args()
    return args



import pandas as pd
import os
from Bio import SeqIO
from collections import Counter

def get_base_stats(seq):
    dimer = []
    length = len(seq)
    base_count = Counter(seq)
    while len(seq)>1:
        dimer.append(seq.pop(0)+seq[0])
    dimer_count = Counter(dimer)
    return length, base_count, dimer_count


def calc_cpg(seq, sum_upper_lower='both', get_basecount=False):
    #print(seq)
    N, base_count, dimer_count = get_base_stats(seq)
    if sum_upper_lower == "both":
        gcount = sum([base_count['G'], base_count['g']])
        ccount = sum([base_count['C'], base_count['c']])
        cpg_count = sum([dimer_count['CG'], dimer_count['Cg'],dimer_count['cG'],dimer_count['cg']])
    if gcount==0:
        cpg_e = 0
        cpg_o = 0
        cpg_oe=0
    elif ccount ==0:
        cpg_e = 0
        cpg_o = 0
        cpg_oe=0
    elif cpg_count==0:
        cpg_e = (gcount*ccount)/N
        cpg_o = 0
        cpg_oe = 0
    else:
        cpg_e = (gcount*ccount)/N
        cpg_o = cpg_count
        cpg_oe = cpg_o/cpg_e
    if get_basecount ==True:
        return cpg_e, cpg_o, cpg_oe, basecount
    else:
        return cpg_e, cpg_o, cpg_oe



def cpg_for_gene_and_flanking_regions(start, stop, scaffold, flanksize=1e3, skipflank=False, strand='+'):
    if strand =='+':
        scaffold_string = list(str(scaffold.seq))
    elif strand=='-':
        scaffold_string = list(str(scaffold.reverse_complement().seq))
    else:
        print("no strand give, defaulting to +")
        scaffold_string = list(str(scaffold.seq))

    #gene
    gene_seq = scaffold_string[start:stop]
    gene_cpg_e,gene_cpg_o, gene_cpg_oe = calc_cpg(gene_seq)
    #print(gene_cpg_oe)
    
    if skipflank==True:    
        return [gene_cpg_e,gene_cpg_o, gene_cpg_oe]
        
    #up_flank
    flank_start = int(start-flanksize)
    if flank_start<0: # make sure we dont overshoot the scaffold boundary
        flank_start=0
    flank_upstream = scaffold_string[flank_start:start]
    flank_u_cpg_e,flank_u_cpg_o, flank_u_cpg_oe = calc_cpg(flank_upstream)
    #print(flank_u_cpg_oe)
    

    #flank_down
    flank_stop = int(stop+flanksize)
    if flank_stop>len(scaffold_string): # make sure we dont overshoot the scaffold boundary
        flank_stop=len(scaffold_string)
    flank_downstream = scaffold_string[stop:flank_stop]
    flank_d_cpg_e,flank_d_cpg_o, flank_d_cpg_oe = calc_cpg(flank_downstream)
    #print(flank_d_cpg_oe)
    
    return [gene_cpg_e,gene_cpg_o, gene_cpg_oe,flank_u_cpg_e,flank_u_cpg_o, flank_u_cpg_oe, flank_d_cpg_e,flank_d_cpg_o, flank_d_cpg_oe]


def run():
    args = cli_parser()
    input_file = './Csec.fna'
    s2 = SeqIO.to_dict(SeqIO.parse(open(input_file),'fasta'))
    gene_pos = pd.read_csv(args.input, sep='\t')
    results = []
    for i, k in gene_pos.iterrows():
#        print(k)
        cpg = cpg_for_gene_and_flanking_regions(start=k.start, stop=k.stop, scaffold=s2[k.scaffold2], skipflank=True)
        results.append([k['type'], k.idstring]+cpg)
    rdf = pd.DataFrame(results)
    rdf.columns = ['featuretype','ID', 'gene_cpg_e','gene_cpg_o', 'gene_cpg_oe']
    outfile = args.input.rsplit('.',1)[0]+'.gene.ex_in.cpg'
    rdf.to_csv(outfile, sep='\t')


if __name__ == "__main__":
    run()