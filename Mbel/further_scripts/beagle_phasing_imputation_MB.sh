#!/bin/bash -l

#SBATCH -A snic2022-22-258
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 20:00:00
#SBATCH -J beagleMB
#SBATCH --mail-type=all
#SBATCH --mail-user=turid.everitt@imbim.uu.se

# Main directories as variables
# Path to dir with the concatenated vcf-file
SEQDIR="/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/vcfs/vcf_final_filt"
# Directory for output
OUTDIR=$SEQDIR

cd $SEQDIR

module load bioinfo-tools
module load Beagle/5.1

# Update the file name
vcf_input="Mbel_concat_excl5scaffolds_rm_indels_hard_filt_excesshet.vcf_biallelic_dpfilt_qualfilt_mac2_maxmiss06_rmfilt.recode.vcf_sedmissing"

# run beagle
java -Xmx4g -jar /sw/apps/bioinfo/Beagle/5.1/rackham/beagle.jar gt=$vcf_input out=$OUTDIR/$vcf_input"_ph_imp"


