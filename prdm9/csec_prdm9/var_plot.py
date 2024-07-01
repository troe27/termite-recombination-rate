import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import  seaborn as sns
from cyvcf2 import VCF
import copy


# import GFF and format
gff = pd.read_csv('../data/GCF_002891405.2_Csec_1.0_genomic_with_introns.gff', sep='\t', comment='#', header=None)
gff.columns = ['scaffold', 'origin','type', 'start', 'end', 'no_idea', 'strand', 'no_idea2', 'IDstring']


# ignore this formatting section, it has todo with the scaffoldnames in the GFF and the VCF
sc = pd.read_csv('../data/GCF_002891405.2_Csec_1.0_assembly_report.txt', sep='\t', comment='#', header=None)
scdict = {k[6]:k[4] for i,k in sc.iterrows()}
gff['scaffold_alt'] = [scdict[i] for i in gff.scaffold]


# only get genes, ignore exon/intron coordinates
gff_gene_only = gff.loc[gff.type=='gene']
gff_gene_only['GID'] = [i.split(';')[0].split('=')[1] for i in gff_gene_only.IDstring]


# get locations and scaffold_name for your favourite gene
prdm9 = gff_gene_only.loc[gff_gene_only.GID=='gene-LOC111864767']
prdm9_start = prdm9.start.iloc[0]
prdm9_end = prdm9.end.iloc[0]
prdm9_scaffold = prdm9.scaffold_alt.iloc[0]


# load the VCF
vcf = VCF('../data/Csec_concat_geq1000_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_no_mac_maxmiss06_rmfilt_MQ70_dp2stdev.recode.vcf', threads=20)


#keep only variants between the start and end of your gene
prdm9_var = []
for variant in vcf:
    if variant.CHROM == prdm9_scaffold:
        if variant.POS > prdm9_start:
            if variant.POS < prdm9_end:
                prdm9_var.append(variant)         


# extract POS, genotypes, alt and reference allele, as well as alternative allele frequency and nucleotide diversity from the filtered variants. these are all fields from the VCF or metrics cyvcf2 calculates on the fly
gt_alt=[]
gt_ref = []
gt_aaf = []
gt_types = []
gt_div = []
pos = []
for i in prdm9_var:
    gt_alt.append(i.ALT)
    gt_aaf.append(i.aaf)
    gt_types.append(i.gt_types)   
    pos.append(i.POS)
    gt_ref.append(i.REF)
    gt_div.append(i.nucl_diversity)
gt_alt = [i[0] for i in gt_alt]


#make a small dataframe with the first four of these measurements
alt_af_df = pd.DataFrame([pos,gt_ref, gt_alt, gt_aaf]).T

# make genotype dataframe
gtdf = pd.DataFrame(gt_types)
#set position as index
gtdf.index=pos
# and set samples as column header
gtdf.columns = vcf.samples




# load GFF file with the PRDM9 annotation. mostl likely i could have also pulled it out of the big GFF, but i was lazy.
gff_file = "../data/Genes_INSDC_annotation_provided_by_Westfaelische_Wilhelms_Univ.GFF3"
prdm9_features = pd.read_csv(gff_file, sep='\t', header=None, comment='#')
prdm_exons = prdm9_features.loc[prdm9_features[2]=='exon'][8]




##########################################################################################################
## Plotting
##########################################################################################################

#Define the figure with 4 individual plots on top of each other, size and the height-ratios, shared x -axis
fig, (ax0,ax,ax1,ax2) = plt.subplots(ncols=1, nrows=4, figsize=(40,8),gridspec_kw={'height_ratios':(5,45,10,10)}, sharex=True
)
# Transpose the gtdf so samples are rows, iterate over rows. for each sample, get a running number, samplename and the genotype array ( a list of ones, twos and threes)
for i, (samplename, sample) in enumerate(gtdf.T.iterrows()):
    # for each sample,get a list of indices ( positions, remember?) where the sample is HOM_ALT, or HET 
    hom_alt_arr  = list(sample.loc[sample==3].index)
    het_alt_arr  = list(sample.loc[sample==1].index)
    # for each position where as sample is HOM_ALT/HET, draw a vertical line (vlines) from i-0.3 to i+0.3, where i is the runnign number for this sample. draw this in maroon for HOM_ALT, and grey for HET. ax indicates that this is on the second plot from the top ( ax0, ax, ax1, ax2) 
    ax.vlines(hom_alt_arr, ymin=i-0.3, ymax=i+0.3, color='maroon', label='Homozygous')
    ax.vlines(het_alt_arr, ymin=i-0.3, ymax=i+0.3, color='grey', label='Heterozygous')
    # draw y-label ticks at the positions of i ( e.g. 0-9) for each samples
ax.set_yticks(list(range(0,9)))
# label with sample-names
ax.set_yticklabels(gtdf.columns) 

# for each of the exons in PRDM9, draw a grey span from start to stop ( k[3] to k[4], that being the 3rd and 4th values of each row i am iterating over. draw this on the first subplot ( ax0)
for i,k in prdm9_features.loc[prdm9_features[2]=='exon'].iterrows():
    ax0.axvspan(k[3], k[4], color='grey')
    #ax0.text(k[3], 0.5, '<- exon', color='red', size=20)


# plot various metrics on subplot ax1 and ax2. i'm lazy here and just connect the dots with lines, which can be treacherous when there is not so much data ( see the middle section) but you can also do fever curves, or simply a plt.scatter(x,y) and draw individual points.
ax1.plot(pos,gt_aaf, color='maroon')
ax2.plot(pos,gt_div, color='grey')

# pretty the layout
plt.tight_layout()


# set the x-axis-limits for ax0, ax and ax1 
ax0.set_xlim(prdm9_start, prdm9_end)
ax.set_xlim(prdm9_start, prdm9_end)
ax1.set_xlim(prdm9_start, prdm9_end)

# take away the box around the plot with the exons
sns.despine(ax=ax0, bottom=True, left=True)

#remove y-ticks on the exon plot
ax0.set_yticks([])

# label a bunch of axes
ax0.set_ylabel('exons', size=20)
ax.set_ylabel('samples-SNPs', size=20)
ax1.set_ylabel('AAF', size=20)
ax2.set_ylabel('nucl div', size=20)

#show the plot
plt.show()


# save figure
# as pdf
plt.savefig("/path/to/figure.pdf")
#as png
plt.savefig("/path/to/figure.png")
