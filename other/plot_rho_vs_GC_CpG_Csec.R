rm(list=ls())

library(wCorr)

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/filt_MQ_val_70_depth_2stdev_from_mean/GC_CpG_SNPdens_corr")

# rho_data_w100kb <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/filt_MQ_val_70_depth_2stdev_from_mean/concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w100kb",header=TRUE)
# # Scaffold	Start_bp	End_bp	Rho_kb	seq_len_with_data_bp
# rho_data_w10kb <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/filt_MQ_val_70_depth_2stdev_from_mean/concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w10kb",header=TRUE)
# rho_data_w1kb <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/filt_MQ_val_70_depth_2stdev_from_mean/concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w1kb",header=TRUE)
# 
# scaff_list <- unique(rho_data_w1kb$Scaffold)
# Not all scaffolds are included in output from LDhat (rho_data) - some probably too short to do any recomb calc on

#********** Scaff len analysis
# scaff_lengths_temp <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/Csec_scaffold_lengths_geq1000_sorted.txt",header=FALSE)
# colnames(scaff_lengths_temp) <- c("Scaffold","Len")
# scaff_lengths <- subset(scaff_lengths_temp,Scaffold %in% scaff_list)
# 
# scaff_lengths$Rho_kb <- rep(0,nrow(scaff_lengths))
# 
# for (i in 1:nrow(scaff_lengths)){
#   scaff <- as.character(scaff_lengths$Scaffold[i])
#   rho_scaff <- subset(rho_data_w1kb,Scaffold==scaff & !is.na(Rho_kb))
#   scaff_lengths$Rho_kb[i] <- sum(rho_scaff$Rho_kb* rho_scaff$seq_len_with_data_bp)/sum(rho_scaff$seq_len_with_data_bp)
# }
# 
# plot(scaff_lengths$Len,scaff_lengths$Rho_kb,type="p",pch=".",cex=2,xlim=c(0,500000))
# hist(scaff_lengths$Len,col="slateblue",breaks=800,xlim=c(0,500000))
#************

# w100kb <- 100000
# w10kb <- 10000
# w1kb <- 1000

#*********** Produce files with positions added to cpg-data, skip this if files already produced ***********

# cpg_data_w100kb_temp <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/CpG/Csec_per_base_content_wind_100000b_xcount.txt",header=TRUE)
# # contig	a_frac	t_frac	g_frac	c_frac	x_count	lower_frac	upper_frac	tot_count	cpg_count	cpg_exp	cpg_obs_exp
# cpg_data_w10kb_temp <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/CpG/Csec_per_base_content_wind_10000b_xcount.txt",header=TRUE)
# cpg_data_w1kb_temp <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/CpG/Csec_per_base_content_wind_1000b_xcount.txt",header=TRUE)
# 
# cpg_data_w100kb <- subset(cpg_data_w100kb_temp,contig %in% scaff_list)
# cpg_data_w10kb <- subset(cpg_data_w10kb_temp,contig %in% scaff_list)
# cpg_data_w1kb <- subset(cpg_data_w1kb_temp,contig %in% scaff_list)
# 
# scaff_lengths_temp <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/Csec_scaffold_lengths_geq1000_sorted.txt",header=FALSE)
# colnames(scaff_lengths_temp) <- c("Scaffold","Len")
# scaff_lengths <- subset(scaff_lengths_temp,Scaffold %in% scaff_list)
# 
# rm(cpg_data_w100kb_temp)
# rm(cpg_data_w10kb_temp)
# rm(cpg_data_w1kb_temp)
# rm(scaff_lengths_temp)
# 
# cpg_data_w100kb$start_pos <- rep(0,nrow(cpg_data_w100kb))
# cpg_data_w100kb$end_pos <- rep(0,nrow(cpg_data_w100kb))
# cpg_data_w100kb$IDX <- 1:nrow(cpg_data_w100kb)
# 
# cpg_data_w10kb$start_pos <- rep(0,nrow(cpg_data_w10kb))
# cpg_data_w10kb$end_pos <- rep(0,nrow(cpg_data_w10kb))
# cpg_data_w10kb$IDX <- 1:nrow(cpg_data_w10kb)
# 
# cpg_data_w1kb$start_pos <- rep(0,nrow(cpg_data_w1kb))
# cpg_data_w1kb$end_pos <- rep(0,nrow(cpg_data_w1kb))
# cpg_data_w1kb$IDX <- 1:nrow(cpg_data_w1kb)

# for (scaff in scaff_list){
#   scaff_len_temp <- subset(scaff_lengths,Scaffold==scaff)
#   scaff_len <- scaff_len_temp$Len
#   
#   to_update_w100kb <- subset(cpg_data_w100kb,contig==scaff)
#   if (scaff_len>w100kb){
#     cpg_data_w100kb[to_update_w100kb$IDX,"start_pos"] <- seq(0,scaff_len-1,by=w100kb)
#     cpg_data_w100kb[to_update_w100kb$IDX,"end_pos"] <- c(seq(w100kb,scaff_len-1,by=w100kb),scaff_len)
#   }
#   else {
#     cpg_data_w100kb[to_update_w100kb$IDX,"start_pos"] <- 0
#     cpg_data_w100kb[to_update_w100kb$IDX,"end_pos"] <- scaff_len
#   }
#   
#   to_update_w10kb <- subset(cpg_data_w10kb,contig==scaff)
#   if (scaff_len>w10kb){
#     cpg_data_w10kb[to_update_w10kb$IDX,"start_pos"] <- seq(0,scaff_len-1,by=w10kb)
#     cpg_data_w10kb[to_update_w10kb$IDX,"end_pos"] <- c(seq(w10kb,scaff_len-1,by=w10kb),scaff_len)
#   }
#   else {
#     cpg_data_w10kb[to_update_w10kb$IDX,"start_pos"] <- 0
#     cpg_data_w10kb[to_update_w10kb$IDX,"end_pos"] <- scaff_len
#   }
#   
#   to_update_w1kb <- subset(cpg_data_w1kb,contig==scaff)
#   if (scaff_len>w1kb) {
#     cpg_data_w1kb[to_update_w1kb$IDX,"start_pos"] <- seq(0,scaff_len-1,by=w1kb)
#     cpg_data_w1kb[to_update_w1kb$IDX,"end_pos"] <- c(seq(w1kb,scaff_len-1,by=w1kb),scaff_len)
#   }
#   else {
#     cpg_data_w1kb[to_update_w1kb$IDX,"start_pos"] <- 0
#     cpg_data_w1kb[to_update_w1kb$IDX,"end_pos"] <- scaff_len
#   }
#   
# }

# write.table(cpg_data_w100kb,"Csec_per_base_content_w100kb_xcount_final_scaffold_set_pos_start_end.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")
# write.table(cpg_data_w10kb,"Csec_per_base_content_w10kb_xcount_final_scaffold_set_pos_start_end.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")
# write.table(cpg_data_w1kb,"Csec_per_base_content_w1kb_xcount_final_scaffold_set_pos_start_end.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")

#***********************************************
# Produce files with rho, CpG, GC and pi for each window, skip this if files already produced

# pi_data_w100kb_temp <- read.table("Csec_concat_geq1000_rmind_hfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_w100kb.pi",header=TRUE)
# #CHROM	BIN_START	BIN_END	N_VARIANTS	PI
# pi_data_w10kb_temp <- read.table("Csec_concat_geq1000_rmind_hfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_w10kb.pi",header=TRUE)
# pi_data_w1kb_temp <- read.table("Csec_concat_geq1000_rmind_hfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_w1kb.pi",header=TRUE)
# 
# pi_data_w100kb <- subset(pi_data_w100kb_temp,CHROM %in% scaff_list)
# pi_data_w10kb <- subset(pi_data_w10kb_temp,CHROM %in% scaff_list)
# pi_data_w1kb <- subset(pi_data_w1kb_temp,CHROM %in% scaff_list)
# 
# rm(pi_data_w100kb_temp)
# rm(pi_data_w10kb_temp)
# rm(pi_data_w1kb_temp)
# 
# 
# cpg_data_w100kb <- read.table("Csec_per_base_content_w100kb_xcount_final_scaffold_set_pos_start_end.txt",header=TRUE)
# # contig	a_frac	t_frac	g_frac	c_frac	x_count	lower_frac	upper_frac	tot_count	cpg_count	cpg_exp	cpg_obs_exp	start_pos	end_pos	IDX
# cpg_data_w10kb <- read.table("Csec_per_base_content_w10kb_xcount_final_scaffold_set_pos_start_end.txt",header=TRUE)
# cpg_data_w1kb <- read.table("Csec_per_base_content_w1kb_xcount_final_scaffold_set_pos_start_end.txt",header=TRUE)
# 
# cpg_data_w100kb$gc_frac <- cpg_data_w100kb$g_frac + cpg_data_w100kb$c_frac
# cpg_data_w10kb$gc_frac <- cpg_data_w10kb$g_frac + cpg_data_w10kb$c_frac
# cpg_data_w1kb$gc_frac <- cpg_data_w1kb$g_frac + cpg_data_w1kb$c_frac
# 
# rho_data_w100kb$IDX <- 1:nrow(rho_data_w100kb)
# rho_data_w10kb$IDX <- 1:nrow(rho_data_w10kb)
# rho_data_w1kb$IDX <- 1:nrow(rho_data_w1kb)
# 
# rho_data_w100kb$cpg_obs_exp <- rep(-10,nrow(rho_data_w100kb))
# rho_data_w10kb$cpg_obs_exp <- rep(-10,nrow(rho_data_w10kb))
# rho_data_w1kb$cpg_obs_exp <- rep(-10,nrow(rho_data_w1kb))
# 
# rho_data_w100kb$gc_frac <- rep(-10,nrow(rho_data_w100kb))
# rho_data_w10kb$gc_frac <- rep(-10,nrow(rho_data_w10kb))
# rho_data_w1kb$gc_frac <- rep(-10,nrow(rho_data_w1kb))
# 
# rho_data_w100kb$pi <- rep(-10,nrow(rho_data_w100kb))
# rho_data_w10kb$pi <- rep(-10,nrow(rho_data_w10kb))
# rho_data_w1kb$pi <- rep(-10,nrow(rho_data_w1kb))


# for (scaff in scaff_list){
#   pi_scaff_w100kb <- subset(pi_data_w100kb, CHROM == scaff)
#   rho_scaff_w100kb <- subset(rho_data_w100kb, Scaffold==scaff)
#   cpg_scaff_w100kb <- subset(cpg_data_w100kb, contig==scaff)
#   for (i in 1:nrow(rho_scaff_w100kb)){
#     rho_mid <- rho_scaff_w100kb$Start_bp[i] + (rho_scaff_w100kb$seq_len_with_data_bp[i]/2)
#     cpg_OL <- subset(cpg_scaff_w100kb,start_pos<rho_mid & end_pos>rho_mid)
#     if (nrow(cpg_OL)==1){
#       rho_data_w100kb[rho_scaff_w100kb$IDX[i],"cpg_obs_exp"] <- cpg_OL$cpg_obs_exp[1]
#       rho_data_w100kb[rho_scaff_w100kb$IDX[i],"gc_frac"] <- cpg_OL$gc_frac[1]
#     }
#     else {
#       print("ERROR")
#       print(nrow(cpg_OL))
#       print(scaff)
#       print(rho_mid)
#       #break
#     }
#     pi_OL <- subset(pi_scaff_w100kb,BIN_START<rho_mid & BIN_END>rho_mid)
#     if (nrow(pi_OL)==1){
#       rho_data_w100kb[rho_scaff_w100kb$IDX[i],"pi"] <- pi_OL$PI[1]
#     }
#     else if (nrow(pi_OL)==0){
#       rho_data_w100kb[rho_scaff_w100kb$IDX[i],"pi"] <- NaN
#     }
#     else {
#       print("ERROR PI")
#       print(nrow(pi_OL))
#       print(scaff)
#       print(rho_mid)
#       #break
#     }
#   }
#   
#   pi_scaff_w10kb <- subset(pi_data_w10kb, CHROM == scaff)
#   rho_scaff_w10kb <- subset(rho_data_w10kb, Scaffold==scaff)
#   cpg_scaff_w10kb <- subset(cpg_data_w10kb, contig==scaff)
#   for (i in 1:nrow(rho_scaff_w10kb)){
#     rho_mid <- rho_scaff_w10kb$Start_bp[i] + (rho_scaff_w10kb$seq_len_with_data_bp[i]/2)
#     cpg_OL <- subset(cpg_scaff_w10kb,start_pos<rho_mid & end_pos>rho_mid)
#     if (nrow(cpg_OL)==1){
#       rho_data_w10kb[rho_scaff_w10kb$IDX[i],"cpg_obs_exp"] <- cpg_OL$cpg_obs_exp[1]
#       rho_data_w10kb[rho_scaff_w10kb$IDX[i],"gc_frac"] <- cpg_OL$gc_frac[1]
#     }
#     else {
#       print("ERROR")
#       print(nrow(cpg_OL))
#       print(scaff)
#       print(rho_mid)
#       #break
#     }
#     pi_OL <- subset(pi_scaff_w10kb,BIN_START<rho_mid & BIN_END>rho_mid)
#     if (nrow(pi_OL)==1){
#       rho_data_w10kb[rho_scaff_w10kb$IDX[i],"pi"] <- pi_OL$PI[1]
#     }
#     else if (nrow(pi_OL)==0){
#       rho_data_w10kb[rho_scaff_w10kb$IDX[i],"pi"] <- NaN
#     }
#     else {
#       print("ERROR PI")
#       print(nrow(pi_OL))
#       print(scaff)
#       print(rho_mid)
#       #break
#     }
#   }
# 
#   pi_scaff_w1kb <- subset(pi_data_w1kb, CHROM == scaff)
#   rho_scaff_w1kb <- subset(rho_data_w1kb, Scaffold==scaff)
#   cpg_scaff_w1kb <- subset(cpg_data_w1kb, contig==scaff)
#   for (i in 1:nrow(rho_scaff_w1kb)){
#     rho_mid <- rho_scaff_w1kb$Start_bp[i] + (rho_scaff_w1kb$seq_len_with_data_bp[i]/2)
#     cpg_OL <- subset(cpg_scaff_w1kb,start_pos<rho_mid & end_pos>rho_mid)
#     if (nrow(cpg_OL)==1){
#       rho_data_w1kb[rho_scaff_w1kb$IDX[i],"cpg_obs_exp"] <- cpg_OL$cpg_obs_exp[1]
#       rho_data_w1kb[rho_scaff_w1kb$IDX[i],"gc_frac"] <- cpg_OL$gc_frac[1]
#     }
#     else {
#       print("ERROR")
#       print(nrow(cpg_OL))
#       print(scaff)
#       print(rho_mid)
#       #break
#     }
#     pi_OL <- subset(pi_scaff_w1kb,BIN_START<rho_mid & BIN_END>rho_mid)
#     if (nrow(pi_OL)==1){
#       rho_data_w1kb[rho_scaff_w1kb$IDX[i],"pi"] <- pi_OL$PI[1]
#     }
#     else if (nrow(pi_OL)==0){
#       rho_data_w1kb[rho_scaff_w1kb$IDX[i],"pi"] <- NaN
#     }
#     else {
#       print("ERROR PI")
#       print(nrow(pi_OL))
#       print(scaff)
#       print(rho_mid)
#       #break
#     }
#   }
# }

# write.table(rho_data_w100kb,"Csec_rho_CpG_GC_pi_finalfilt_MQ70_dp2stdev_w100kb.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")
# write.table(rho_data_w10kb,"Csec_rho_CpG_GC_pi_finalfilt_MQ70_dp2stdev_w10kb.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")
# write.table(rho_data_w1kb,"Csec_rho_CpG_GC_pi_finalfilt_MQ70_dp2stdev_w1kb.txt",row.names=FALSE,col.names=TRUE,quote=FALSE,sep="\t")

# ********************************************
# Start here if above files already produced:

rho_data_w100kb <- read.table("Csec_rho_CpG_GC_pi_finalfilt_MQ70_dp2stdev_w100kb.txt",header=TRUE)
rho_data_w10kb <- read.table("Csec_rho_CpG_GC_pi_finalfilt_MQ70_dp2stdev_w10kb.txt",header=TRUE)
rho_data_w1kb <- read.table("Csec_rho_CpG_GC_pi_finalfilt_MQ70_dp2stdev_w1kb.txt",header=TRUE)
#Scaffold	Start_bp	End_bp	Rho_kb	seq_len_with_data_bp	IDX	cpg_obs_exp	gc_frac	pi

#********* To remove the shortest scaffolds
# scaff_lengths_temp <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/Csec_scaffold_lengths_geq1000_sorted.txt",header=FALSE)
# colnames(scaff_lengths_temp) <- c("Scaffold","Len")
# min_len <- 10000 
# scaff_lengths_temp_geqXkb <- subset(scaff_lengths_temp, Len >= min_len)
# num_bp <- sum(scaff_lengths_temp_geqXkb$Len)
# Csec_tot_len_nofilt <- 1018932804

# scaff_list <- unique(rho_data_w1kb$Scaffold)
# # Not all scaffolds are included in output from LDhat (rho_data) - some probably too short to do any recomb calc on
# scaff_lengths <- subset(scaff_lengths_temp,Scaffold %in% scaff_list & Len >= min_len)
# scaff_list <- scaff_lengths$Scaffold
# 
# rho_data_w100kb <- subset(rho_data_w100kb,Scaffold %in% scaff_list)
# rho_data_w10kb <- subset(rho_data_w10kb,Scaffold %in% scaff_list)
# rho_data_w1kb <- subset(rho_data_w1kb,Scaffold %in% scaff_list)
# 
# plot_title <- paste("Csec, scaffolds >= ",min_len," bp = ",nrow(scaff_lengths)," scaffolds = ",round(100*num_bp/Csec_tot_len_nofilt,digits=2),"% of tot seq length",sep="")
#********

# Exclude windows shorter than half wind size when plotting the data (windows on short scaffolds/ends of scaffolds)
rho_data_w100kb_plot <- subset(rho_data_w100kb,seq_len_with_data_bp >= 50000)
rho_data_w10kb_plot <- subset(rho_data_w10kb,seq_len_with_data_bp >= 5000)
rho_data_w1kb_plot <- subset(rho_data_w1kb,seq_len_with_data_bp >= 500)

rho_data_w100kb_plot_len <- sum(rho_data_w100kb_plot$seq_len_with_data_bp)
rho_data_w10kb_plot_len <- sum(rho_data_w10kb_plot$seq_len_with_data_bp)
rho_data_w1kb_plot_len <- sum(rho_data_w1kb_plot$seq_len_with_data_bp)

rho_data_w100kb_tot_len <- sum(rho_data_w100kb$seq_len_with_data_bp)
rho_data_w10kb_tot_len <- sum(rho_data_w10kb$seq_len_with_data_bp)
rho_data_w1kb_tot_len <- sum(rho_data_w1kb$seq_len_with_data_bp)

#*********

par(mfrow=c(1,3))
# plot_title <- paste("Csec, windows >= half wind length = ",round(100*rho_data_w100kb_plot_len/rho_data_w100kb_tot_len,digits=2)," % of tot seq length")
# plot(rho_data_w100kb_plot$cpg_obs_exp,rho_data_w100kb_plot$Rho_kb,type="p",pch=".",main=plot_title)
# plot(rho_data_w100kb_plot$gc_frac,rho_data_w100kb_plot$Rho_kb,type="p",pch=".")
# plot(rho_data_w100kb_plot$pi,rho_data_w100kb_plot$Rho_kb,type="p",pch=".")

plot_title <- paste("Csec, w10kb, windows >= half wind length = ",round(100*rho_data_w10kb_plot_len/rho_data_w10kb_tot_len,digits=2)," % of tot seq length")
plot(rho_data_w10kb_plot$cpg_obs_exp,rho_data_w10kb_plot$Rho_kb,type="p",pch=".",main=plot_title,xlab="CpG obs/exp",ylab="Rho/kb",cex.lab=1.5,cex.axis=1.5,cex=3)
plot(rho_data_w10kb_plot$gc_frac,rho_data_w10kb_plot$Rho_kb,type="p",pch=".",xlab="GC-content",ylab="Rho/kb",cex.lab=1.5,cex.axis=1.5,cex=3)
plot(rho_data_w10kb_plot$pi,rho_data_w10kb_plot$Rho_kb,type="p",pch=".",xlab="PI",ylab="Rho/kb",cex.lab=1.5,cex.axis=1.5,cex=3)

# plot_title <- paste("Csec, windows >= half wind length = ",round(100*rho_data_w1kb_plot_len/rho_data_w1kb_tot_len,digits=2)," % of tot seq length")
# plot(rho_data_w1kb_plot$cpg_obs_exp,rho_data_w1kb_plot$Rho_kb,type="p",pch=".",main=plot_title, xlim=c(0,8),xlab="CpG obs/exp, truncated")
# plot(rho_data_w1kb_plot$gc_frac,rho_data_w1kb_plot$Rho_kb,type="p",pch=".")
# plot(rho_data_w1kb_plot$pi,rho_data_w1kb_plot$Rho_kb,type="p",pch=".")

#******** Calc weighted corr and permutation-based p-values (not excluding any windows)

rho_data_w100kb_no_nan <- subset(rho_data_w100kb,!is.na(Rho_kb) & !is.na(cpg_obs_exp) & !is.na(gc_frac) & !is.na(pi) & !is.na(seq_len_with_data_bp))
rho_data_w10kb_no_nan <- subset(rho_data_w10kb,!is.na(Rho_kb) & !is.na(cpg_obs_exp) & !is.na(gc_frac) & !is.na(pi) & !is.na(seq_len_with_data_bp))
rho_data_w1kb_no_nan <- subset(rho_data_w1kb,!is.na(Rho_kb) & !is.na(cpg_obs_exp) & !is.na(gc_frac) & !is.na(pi) & !is.na(seq_len_with_data_bp))

cpg_corr_w100kb <- weightedCorr(rho_data_w100kb_no_nan$Rho_kb,rho_data_w100kb_no_nan$cpg_obs_exp,method="spearman",weights=rho_data_w100kb_no_nan$seq_len_with_data_bp)
gc_corr_w100kb <- weightedCorr(rho_data_w100kb_no_nan$Rho_kb,rho_data_w100kb_no_nan$gc_frac,method="spearman",weights=rho_data_w100kb_no_nan$seq_len_with_data_bp)
pi_corr_w100kb <- weightedCorr(rho_data_w100kb_no_nan$Rho_kb,rho_data_w100kb_no_nan$pi,method="spearman",weights=rho_data_w100kb_no_nan$seq_len_with_data_bp)

n_iter <- 1000

cpg_corr_perm_w100kb <- rep(0,n_iter)
gc_corr_perm_w100kb <- rep(0,n_iter)
pi_corr_perm_w100kb <- rep(0,n_iter)

idx_list <- 1:nrow(rho_data_w100kb_no_nan)
for (i in 1:n_iter){
  idx_list_perm <- sample(idx_list,size=nrow(rho_data_w100kb_no_nan),replace=FALSE)
  w_list <- (rho_data_w100kb_no_nan$seq_len_with_data_bp + rho_data_w100kb_no_nan$seq_len_with_data_bp[idx_list_perm])/2
  cpg_corr_perm_w100kb[i] <- weightedCorr(rho_data_w100kb_no_nan$Rho_kb,rho_data_w100kb_no_nan$cpg_obs_exp[idx_list_perm],method="spearman",weights=w_list)
  gc_corr_perm_w100kb[i] <- weightedCorr(rho_data_w100kb_no_nan$Rho_kb,rho_data_w100kb_no_nan$gc[idx_list_perm],method="spearman",weights=w_list)
  pi_corr_perm_w100kb[i] <- weightedCorr(rho_data_w100kb_no_nan$Rho_kb,rho_data_w100kb_no_nan$pi[idx_list_perm],method="spearman",weights=w_list)
}

cpg_w100kb_p <- length(subset(cpg_corr_perm_w100kb,cpg_corr_perm_w100kb>=cpg_corr_w100kb | cpg_corr_perm_w100kb<=-cpg_corr_w100kb))/n_iter
gc_w100kb_p <- length(subset(gc_corr_perm_w100kb,gc_corr_perm_w100kb>=gc_corr_w100kb | gc_corr_perm_w100kb<=-gc_corr_w100kb))/n_iter
pi_w100kb_p <- length(subset(pi_corr_perm_w100kb,pi_corr_perm_w100kb>=pi_corr_w100kb | pi_corr_perm_w100kb<=-pi_corr_w100kb))/n_iter

par(mfrow=c(3,3))
hist(c(cpg_corr_perm_w100kb,cpg_corr_w100kb),col="slateblue")
abline(v=cpg_corr_w100kb,lty=2,col="red")

hist(c(gc_corr_perm_w100kb,gc_corr_w100kb),col="slateblue")
abline(v=gc_corr_w100kb,lty=2,col="red")

hist(c(pi_corr_perm_w100kb,pi_corr_w100kb),col="slateblue")
abline(v=pi_corr_w100kb,lty=2,col="red")

print(cpg_w100kb_p)
print(gc_w100kb_p)
print(pi_w100kb_p)

cpg_corr_w10kb <- weightedCorr(rho_data_w10kb_no_nan$Rho_kb,rho_data_w10kb_no_nan$cpg_obs_exp,method="spearman",weights=rho_data_w10kb_no_nan$seq_len_with_data_bp)
gc_corr_w10kb <- weightedCorr(rho_data_w10kb_no_nan$Rho_kb,rho_data_w10kb_no_nan$gc_frac,method="spearman",weights=rho_data_w10kb_no_nan$seq_len_with_data_bp)
pi_corr_w10kb <-weightedCorr(rho_data_w10kb_no_nan$Rho_kb,rho_data_w10kb_no_nan$pi,method="spearman",weights=rho_data_w10kb_no_nan$seq_len_with_data_bp)

cpg_corr_perm_w10kb <- rep(0,n_iter)
gc_corr_perm_w10kb <- rep(0,n_iter)
pi_corr_perm_w10kb <- rep(0,n_iter)

idx_list <- 1:nrow(rho_data_w10kb_no_nan)
for (i in 1:n_iter){
  idx_list_perm <- sample(idx_list,size=nrow(rho_data_w10kb_no_nan),replace=FALSE)
  w_list <- (rho_data_w10kb_no_nan$seq_len_with_data_bp + rho_data_w10kb_no_nan$seq_len_with_data_bp[idx_list_perm])/2
  cpg_corr_perm_w10kb[i] <- weightedCorr(rho_data_w10kb_no_nan$Rho_kb,rho_data_w10kb_no_nan$cpg_obs_exp[idx_list_perm],method="spearman",weights=w_list)
  gc_corr_perm_w10kb[i] <- weightedCorr(rho_data_w10kb_no_nan$Rho_kb,rho_data_w10kb_no_nan$gc[idx_list_perm],method="spearman",weights=w_list)
  pi_corr_perm_w10kb[i] <- weightedCorr(rho_data_w10kb_no_nan$Rho_kb,rho_data_w10kb_no_nan$pi[idx_list_perm],method="spearman",weights=w_list)
}

cpg_w10kb_p <- length(subset(cpg_corr_perm_w10kb,cpg_corr_perm_w10kb>=cpg_corr_w10kb | cpg_corr_perm_w10kb<=-cpg_corr_w10kb))/n_iter
gc_w10kb_p <- length(subset(gc_corr_perm_w10kb,gc_corr_perm_w10kb>=gc_corr_w10kb | gc_corr_perm_w10kb<=-gc_corr_w10kb))/n_iter
pi_w10kb_p <- length(subset(pi_corr_perm_w10kb,pi_corr_perm_w10kb>=pi_corr_w10kb | pi_corr_perm_w10kb<=-pi_corr_w10kb))/n_iter

hist(c(cpg_corr_perm_w10kb,cpg_corr_w10kb),col="slateblue")
abline(v=cpg_corr_w10kb,lty=2,col="red")

hist(c(gc_corr_perm_w10kb,gc_corr_w10kb),col="slateblue")
abline(v=gc_corr_w10kb,lty=2,col="red")

hist(c(pi_corr_perm_w10kb,pi_corr_w10kb),col="slateblue")
abline(v=pi_corr_w10kb,lty=2,col="red")

print(cpg_w10kb_p)
print(gc_w10kb_p)
print(pi_w10kb_p)

# cpg_corr_w1kb <- weightedCorr(rho_data_w1kb_no_nan$Rho_kb,rho_data_w1kb_no_nan$cpg_obs_exp,method="spearman",weights=rho_data_w1kb_no_nan$seq_len_with_data_bp)
# gc_corr_w1kb <- weightedCorr(rho_data_w1kb_no_nan$Rho_kb,rho_data_w1kb_no_nan$gc_frac,method="spearman",weights=rho_data_w1kb_no_nan$seq_len_with_data_bp)
# pi_corr_w1kb <- weightedCorr(rho_data_w1kb_no_nan$Rho_kb,rho_data_w1kb_no_nan$pi,method="spearman",weights=rho_data_w1kb_no_nan$seq_len_with_data_bp)
# 
# cpg_corr_perm_w1kb <- rep(0,n_iter)
# gc_corr_perm_w1kb <- rep(0,n_iter)
# pi_corr_perm_w1kb <- rep(0,n_iter)
# 
# idx_list <- 1:nrow(rho_data_w1kb_no_nan)
# for (i in 1:n_iter){
#   idx_list_perm <- sample(idx_list,size=nrow(rho_data_w1kb_no_nan),replace=FALSE)
#   w_list <- (rho_data_w1kb_no_nan$seq_len_with_data_bp + rho_data_w1kb_no_nan$seq_len_with_data_bp[idx_list_perm])/2
#   cpg_corr_perm_w1kb[i] <- weightedCorr(rho_data_w1kb_no_nan$Rho_kb,rho_data_w1kb_no_nan$cpg_obs_exp[idx_list_perm],method="spearman",weights=w_list)
#   gc_corr_perm_w1kb[i] <- weightedCorr(rho_data_w1kb_no_nan$Rho_kb,rho_data_w1kb_no_nan$gc[idx_list_perm],method="spearman",weights=w_list)
#   pi_corr_perm_w1kb[i] <- weightedCorr(rho_data_w1kb_no_nan$Rho_kb,rho_data_w1kb_no_nan$pi[idx_list_perm],method="spearman",weights=w_list)
# }
# 
# cpg_w1kb_p <- length(subset(cpg_corr_perm_w1kb,cpg_corr_perm_w1kb>=cpg_corr_w1kb | cpg_corr_perm_w1kb<=-cpg_corr_w1kb))/n_iter
# gc_w1kb_p <- length(subset(gc_corr_perm_w1kb,gc_corr_perm_w1kb>=gc_corr_w1kb | gc_corr_perm_w1kb<=-gc_corr_w1kb))/n_iter
# pi_w1kb_p <- length(subset(pi_corr_perm_w1kb,pi_corr_perm_w1kb>=pi_corr_w1kb | pi_corr_perm_w1kb<=-pi_corr_w1kb))/n_iter
# 
# hist(c(cpg_corr_perm_w1kb,cpg_corr_w1kb),col="slateblue")
# abline(v=cpg_corr_w1kb,lty=2,col="red")
# 
# hist(c(gc_corr_perm_w1kb,gc_corr_w1kb),col="slateblue")
# abline(v=gc_corr_w1kb,lty=2,col="red")
# 
# hist(c(pi_corr_perm_w1kb,pi_corr_w1kb),col="slateblue")
# abline(v=pi_corr_w1kb,lty=2,col="red")
# 
# print(cpg_w1kb_p)
# print(gc_w1kb_p)
# print(pi_w1kb_p)

















