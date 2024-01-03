rm(list=ls())

setwd("/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/LDhat/rho_for_annotation")

rho_data <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp.vcf_LDhat_bpen1_statres_100N_red.txt",header=TRUE)
gff_data <- read.table("braker.gff3_red",header=TRUE)
gff_data$Mean_rho <- rep(0,nrow(gff_data))
gff_data$length_rho <- rep(0,nrow(gff_data))
k <- 1000

for (i in 1:nrow(gff_data)){
  gff_start <- gff_data$Start_pos[i]
  gff_end <- gff_data$End_pos[i]
  gff_scaff <- as.character(gff_data$Scaffold[i])
  rhosum <- 0
  len_bp <- 0
  rho_subset <- subset(rho_data, Scaffold==gff_scaff & (Pos_kb_start*k)<gff_end & (Pos_kb_end*k)>gff_start)
  if (nrow(rho_subset)>0){
    for (j in 1:nrow(rho_subset)){
      rho_start <- rho_subset$Pos_kb_start[j]*k
      rho_end <- rho_subset$Pos_kb_end[j]*k
      overlap <- min(c(gff_end,rho_end)) - max(c(gff_start,rho_start)) 
      len_bp <- len_bp + overlap
      rhosum <- rhosum + rho_subset$Mean_rho[j]*overlap/k
    }
    gff_data$Mean_rho[i] <- rhosum/len_bp
    gff_data$length_rho[i] <- len_bp
  }
}

write.table(gff_data,file="Mbel_braker_gff_rho.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")
