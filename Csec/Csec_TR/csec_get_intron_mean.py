import pandas as pd
import os
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import scipy
import argparse


# def function
def cli_parser():
    '''
    parses command line input
   
    '''
    parser_main = argparse.ArgumentParser(prog='get_intron_mean.py')
    parser_main.add_argument("--genelist",
                             help="geneID's, one per line",
                             required = True)
    parser_main.add_argument("--batchname", help="batchname or number",required = True)
    args = parser_main.parse_args()
    return args



args = cli_parser()

with open(args.genelist, 'rt') as handle:
    genelist = handle.read().split('\n')

# file locations
    #Csec
        #rho
Csec_rho_gene_and_flank = pd.read_csv('./Csec/20230919_Csec_rho_per_gene_and_50kbflank_with_10kbbuffer_newfilt.tsv', sep='\t')
Csec_rho_exon_and_intron = pd.read_csv('/proj/snic2021-23-365/private/TR_20230707/TR_20230707_per_gene_analysis/Csec/old_data/rho_per_gene/20230717_Csec_rho_exons_and_introns.tsv', sep='\t', index_col=0)
Csec_rho_exon_and_intron.columns = ['scaffold', 'source', 'featuretype', 'start', 'stop', 'n', 'strand', 'n2', 'ID', 'scaffold_alt', 'rho']
        #CpG
Csec_CpG_gene_and_flank = pd.read_csv( './Csec/old_data/20230810_Csec_CpG_per_gene_and_50kbflank_10kbbuffer.tsv', sep='\t', index_col=0)
Csec_CpG_exon_and_intron = pd.read_csv('/proj/snic2021-23-365/private/TR_20230707/TR_20230707_per_gene_analysis/Csec/old_data/20230717_Csec_CpG_exons_and_introns.tsv', sep='\t', index_col=0)

    #Mbel
        #rho



Csec_rho_gene_and_flank = Csec_rho_gene_and_flank.dropna(subset=['weighted_mean_rho_gene', 'weighted_mean_rho_uflank', 'weighted_mean_rho_dflank'], how='any')

Csec_gene_and_flank = pd.merge(left=Csec_rho_gene_and_flank, right=Csec_CpG_gene_and_flank, left_on='idstring', right_on='ID', how='left')

Csec_exin = pd.merge(left=Csec_CpG_exon_and_intron, right=Csec_rho_exon_and_intron, left_on=['ID','featuretype'], right_on=['ID','featuretype'])

# generating the intron positions with Genometools has left the IDstring somewhat sparse, only denoting parent RNA.
# here i use the richer ID-string of the exons to link parent-RNA to the genebank ID

ID_dict = {}
for i in Csec_exin.loc[Csec_exin.featuretype=='exon'].ID:
    idfields = i.split(';')
    idict = {i.split('=')[0]:i.split('=')[1] for i in idfields}
    ID_dict[idict['Parent']] = idict['Dbxref']


def extract_id(idstring, idtype = 'Dbxref', ID_dict=False):
    if ID_dict == False:
        idfields = idstring.split(';')
        idict = {i.split('=')[0]:i.split('=')[1] for i in idfields}
        return idict[idtype].split(',')[0]
    else:
        idfields = idstring.split(';')
        idict = {i.split('=')[0]:i.split('=')[1] for i in idfields}
        try:
            return idict[idtype].split(',')[0]
        except KeyError:
            return ID_dict[idict['Parent']].split(',')[0]


Csec_gene_and_flank['GeneID'] = [extract_id(i) for i in Csec_gene_and_flank.ID]

Csec_exin['GeneID'] = [extract_id(i, ID_dict=ID_dict) for i in Csec_exin.ID]

# remnove superfluous columns
Csec_gene_and_flank = Csec_gene_and_flank[['scaffold', 'weighted_mean_rho_gene', 'weighted_mean_rho_uflank',
       'weighted_mean_rho_dflank', 'ID', 'gene_cpg_e',
       'gene_cpg_o', 'gene_cpg_oe', 'flank_u_cpg_e', 'flank_u_cpg_o',
       'flank_u_cpg_oe', 'flank_d_cpg_e', 'flank_d_cpg_o', 'flank_d_cpg_oe',
       'GeneID']]


# rename scaffold and rho columns to avoid issues down the line
Csec_exin.columns = ['featuretype', 'ID', 'gene_cpg_e', 'gene_cpg_o', 'gene_cpg_oe',
       'scaffold2', 'source', 'start', 'stop', 'n', 'strand', 'n2',
       'scaffold', 'weighted_mean_rho_gene', 'GeneID']

# remnove superfluous columns
Csec_exin = Csec_exin[['featuretype', 'ID', 'gene_cpg_e', 'gene_cpg_o', 'gene_cpg_oe','source', 'start', 'stop', 'n', 'strand', 'n2','scaffold', 'weighted_mean_rho_gene', 'GeneID']]


# propagate filtering to exin_data
Csec_genefilt = dict.fromkeys(Csec_gene_and_flank.GeneID)

Csec_exin = Csec_exin.loc[Csec_exin.GeneID.isin(Csec_genefilt)]

merged_Csec = pd.concat([Csec_gene_and_flank, Csec_exin])

merged_Csec['featurelength'] = merged_Csec['stop'] - merged_Csec['start']

def get_mean_rho(df, gene):
    df = df.loc[df.GeneID==gene]
    m_l = df.weighted_mean_rho_gene.astype(float)*df.featurelength.astype(float)
    return np.sum(m_l)/df.featurelength.sum()
    

Csec_intron_weighted_mean_rho = []
for i in genelist:
    
    val = get_mean_rho(df=merged_Csec.loc[merged_Csec.featuretype=='intron'],gene=i)
    Csec_intron_weighted_mean_rho.append([i, val])


pd.DataFrame(Csec_intron_weighted_mean_rho).to_csv('csec_intron_batch_gene/20230920_{batch}_Csec_intron_weighted_mean_rho.csv'.format(batch=args.batchname))