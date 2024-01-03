#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 08:00:00
#SBATCH -J dbimport
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables

# Update this with the path to the directory where you have the sample-name-map from the previous step
SEQDIR="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec/gvcf"

# The sample-name-map that you created in the previous step (tab-separated list of each sample name followed by the full path to its .g.vcf-file. One line per sample.)
SAMP_NAME="/proj/snic2022-23-268/private/termite_analysis/Csec/samp_name_map_wout_CS8.txt"

# The path to the directory where you want to have the output files
# I'd recommend you create a separate directory for this
OUTDIR="/proj/snic2022-23-268/private/termite_analysis/Csec/db_and_vcfs_wout_CS8"

# Reference sequence
# Update this with the path and file name for your ref genome
REF="/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec/Csec.fna"

module load bioinfo-tools
module load GATK/4.0.8.0 #Need to use GATK4 for GenomicsDBImport

gatk SelectVariants -R $REF -V "/proj/snic2021-23-365/nobackup/tuuli/termites/C_sec/gvcf/CS_1.sorted.marked_dupes.rg.g.vcf.gz" -O temp_CS_1_test.vcf










