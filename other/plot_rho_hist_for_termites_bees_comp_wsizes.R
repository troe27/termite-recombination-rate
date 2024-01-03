rm(list=ls())

library(weights)

par(mfrow=c(3,3))

sd_factor <- 4

#************* Csec

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/filt_MQ_val_70_depth_2stdev_from_mean")

Csec_rho_data_w1kb_temp <- read.table("concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w1kb",header=TRUE)
#Scaffold	Start_bp	End_bp	Rho_kb	seq_len_with_data_bp
Csec_rho_data_w10kb_temp <- read.table("concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w10kb",header=TRUE)
Csec_rho_data_w100kb_temp <- read.table("concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w100kb",header=TRUE)

Csec_rho_data_w1kb <- subset(Csec_rho_data_w1kb_temp,!is.na(Rho_kb))
Csec_rho_data_w10kb <- subset(Csec_rho_data_w10kb_temp,!is.na(Rho_kb))
Csec_rho_data_w100kb <- subset(Csec_rho_data_w100kb_temp,!is.na(Rho_kb))

rm(Csec_rho_data_w1kb_temp)
rm(Csec_rho_data_w10kb_temp)
rm(Csec_rho_data_w100kb_temp)

# Weighted estimates of mean and std.dev for Csec and Mbel, because we know the exact length of each window (sometimes shorter than the given window size, e.g. at end of scaffolds)
# For Amel, exact length of each window unknown, have to assume that all windows are the given length. Also much longer scaffolds (chromosomes) so should make less difference.
# For Csec, many short scaffolds. With big windows (10 kb, 100 kb) many scaffolds are shorter than the window size. 
# Weighted histograms for Csec and Mbel, but not for Amel, for the same reason

Csec_mean1 <- sum(Csec_rho_data_w1kb$Rho_kb*Csec_rho_data_w1kb$seq_len_with_data_bp)/sum(Csec_rho_data_w1kb$seq_len_with_data_bp)
Csec_mean10 <- sum(Csec_rho_data_w10kb$Rho_kb*Csec_rho_data_w10kb$seq_len_with_data_bp)/sum(Csec_rho_data_w10kb$seq_len_with_data_bp)
Csec_mean100 <- sum(Csec_rho_data_w100kb$Rho_kb*Csec_rho_data_w100kb$seq_len_with_data_bp)/sum(Csec_rho_data_w100kb$seq_len_with_data_bp)

Csec_rho_data_w1kb$sq_diff_to_mean <- (Csec_rho_data_w1kb$Rho_kb - Csec_mean1)^2
Csec_rho_data_w10kb$sq_diff_to_mean <- (Csec_rho_data_w10kb$Rho_kb - Csec_mean10)^2
Csec_rho_data_w100kb$sq_diff_to_mean <- (Csec_rho_data_w100kb$Rho_kb - Csec_mean100)^2

Csec_sd1 <- sqrt(sum(Csec_rho_data_w1kb$sq_diff_to_mean*Csec_rho_data_w1kb$seq_len_with_data_bp)/(sum(Csec_rho_data_w1kb$seq_len_with_data_bp)-1))
Csec_sd10 <- sqrt(sum(Csec_rho_data_w10kb$sq_diff_to_mean*Csec_rho_data_w10kb$seq_len_with_data_bp)/(sum(Csec_rho_data_w10kb$seq_len_with_data_bp)-1))
Csec_sd100 <- sqrt(sum(Csec_rho_data_w100kb$sq_diff_to_mean*Csec_rho_data_w100kb$seq_len_with_data_bp)/(sum(Csec_rho_data_w100kb$seq_len_with_data_bp)-1))

Csec_x_max1 <- Csec_mean1 + sd_factor*Csec_sd1
print(Csec_x_max1)
Csec_x_max10 <- Csec_mean10 + sd_factor*Csec_sd10
print(Csec_x_max10)
Csec_x_max100 <- Csec_mean100 + sd_factor*Csec_sd100
print(Csec_x_max100)

cex_val <- 1.25

wtd.hist(Csec_rho_data_w1kb$Rho_kb,weight=Csec_rho_data_w1kb$seq_len_with_data_bp,col="slateblue",breaks=100,main="C. secundus, wind. size 1 kbp",xlim=c(0,Csec_x_max1),xlab=paste("Rho/kbp, truncated at mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val)
wtd.hist(Csec_rho_data_w10kb$Rho_kb,weight=Csec_rho_data_w10kb$seq_len_with_data_bp,col="slateblue",breaks=100,main="Wind. size 10 kbp",xlim=c(0,Csec_x_max10),xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val)
wtd.hist(Csec_rho_data_w100kb$Rho_kb,weight=Csec_rho_data_w100kb$seq_len_with_data_bp,col="slateblue",breaks=100,main="Wind. size 100 kbp",xlim=c(0,Csec_x_max100),xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val)

# Replace rho-values higher than x_max by x_max, so that they are plotted in the same bin (highest bin on x-axis). Plots for all species at end of script

Csec_rho_data_w1kb$IDX <- 1:nrow(Csec_rho_data_w1kb)
Csec_rho_data_w10kb$IDX <- 1:nrow(Csec_rho_data_w10kb)
Csec_rho_data_w100kb$IDX <- 1:nrow(Csec_rho_data_w100kb)

Csec_rho_data_w1kb$Rho_mod <- Csec_rho_data_w1kb$Rho_kb
Csec_rho_data_w10kb$Rho_mod <- Csec_rho_data_w10kb$Rho_kb
Csec_rho_data_w100kb$Rho_mod <- Csec_rho_data_w100kb$Rho_kb

Csec_rho_data_w1kb_high_rho <- subset(Csec_rho_data_w1kb, Rho_kb >= Csec_x_max1)
Csec_rho_data_w10kb_high_rho <- subset(Csec_rho_data_w10kb, Rho_kb >= Csec_x_max10)
Csec_rho_data_w100kb_high_rho <- subset(Csec_rho_data_w100kb, Rho_kb >= Csec_x_max100)

Csec_rho_data_w1kb$Rho_mod[Csec_rho_data_w1kb_high_rho$IDX] <- Csec_x_max1
Csec_rho_data_w10kb$Rho_mod[Csec_rho_data_w10kb_high_rho$IDX] <- Csec_x_max10
Csec_rho_data_w100kb$Rho_mod[Csec_rho_data_w100kb_high_rho$IDX] <- Csec_x_max100

#*************** Mbel

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Mbel_100N/filt_MQ_val_70_depth_2stdev_from_mean")

Mbel_rho_data_w1kb_temp <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt_w1kb",header=TRUE)
#Scaffold	Start_bp	End_bp	Rho_kb	seq_len_with_data_bp
Mbel_rho_data_w10kb_temp <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt_w10kb",header=TRUE)
Mbel_rho_data_w100kb_temp <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt_w100kb",header=TRUE)

Mbel_rho_data_w1kb <- subset(Mbel_rho_data_w1kb_temp,!is.na(Rho_kb))
Mbel_rho_data_w10kb <- subset(Mbel_rho_data_w10kb_temp,!is.na(Rho_kb))
Mbel_rho_data_w100kb <- subset(Mbel_rho_data_w100kb_temp,!is.na(Rho_kb))

rm(Mbel_rho_data_w1kb_temp)
rm(Mbel_rho_data_w10kb_temp)
rm(Mbel_rho_data_w100kb_temp)

Mbel_mean1 <- sum(Mbel_rho_data_w1kb$Rho_kb*Mbel_rho_data_w1kb$seq_len_with_data_bp)/sum(Mbel_rho_data_w1kb$seq_len_with_data_bp)
Mbel_mean10 <- sum(Mbel_rho_data_w10kb$Rho_kb*Mbel_rho_data_w10kb$seq_len_with_data_bp)/sum(Mbel_rho_data_w10kb$seq_len_with_data_bp)
Mbel_mean100 <- sum(Mbel_rho_data_w100kb$Rho_kb*Mbel_rho_data_w100kb$seq_len_with_data_bp)/sum(Mbel_rho_data_w100kb$seq_len_with_data_bp)

Mbel_rho_data_w1kb$sq_diff_to_mean <- (Mbel_rho_data_w1kb$Rho_kb - Mbel_mean1)^2
Mbel_rho_data_w10kb$sq_diff_to_mean <- (Mbel_rho_data_w10kb$Rho_kb - Mbel_mean10)^2
Mbel_rho_data_w100kb$sq_diff_to_mean <- (Mbel_rho_data_w100kb$Rho_kb - Mbel_mean100)^2

Mbel_sd1 <- sqrt(sum(Mbel_rho_data_w1kb$sq_diff_to_mean*Mbel_rho_data_w1kb$seq_len_with_data_bp)/(sum(Mbel_rho_data_w1kb$seq_len_with_data_bp)-1))
Mbel_sd10 <- sqrt(sum(Mbel_rho_data_w10kb$sq_diff_to_mean*Mbel_rho_data_w10kb$seq_len_with_data_bp)/(sum(Mbel_rho_data_w10kb$seq_len_with_data_bp)-1))
Mbel_sd100 <- sqrt(sum(Mbel_rho_data_w100kb$sq_diff_to_mean*Mbel_rho_data_w100kb$seq_len_with_data_bp)/(sum(Mbel_rho_data_w100kb$seq_len_with_data_bp)-1))

Mbel_x_max1 <- Mbel_mean1 + sd_factor*Mbel_sd1
print(Mbel_x_max1)
Mbel_x_max10 <- Mbel_mean10 + sd_factor*Mbel_sd10
print(Mbel_x_max10)
Mbel_x_max100 <- Mbel_mean100 + sd_factor*Mbel_sd100
print(Mbel_x_max100)

wtd.hist(Mbel_rho_data_w1kb$Rho_kb,weight=Mbel_rho_data_w1kb$seq_len_with_data_bp,col="slateblue",breaks=200,main="M. bellicosus, wind. size 1 kbp",xlim=c(0,Mbel_x_max1),xlab=paste("Rho/kbp, truncated at mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val)
wtd.hist(Mbel_rho_data_w10kb$Rho_kb,weight=Mbel_rho_data_w10kb$seq_len_with_data_bp,col="slateblue",breaks=200,main="Wind. size 10 kbp",xlim=c(0,Mbel_x_max10),xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val)
wtd.hist(Mbel_rho_data_w100kb$Rho_kb,weight=Mbel_rho_data_w100kb$seq_len_with_data_bp,col="slateblue",breaks=200,main="Wind. size 100 kbp",xlim=c(0,Mbel_x_max100),xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val)

Mbel_rho_data_w1kb$IDX <- 1:nrow(Mbel_rho_data_w1kb)
Mbel_rho_data_w10kb$IDX <- 1:nrow(Mbel_rho_data_w10kb)
Mbel_rho_data_w100kb$IDX <- 1:nrow(Mbel_rho_data_w100kb)

Mbel_rho_data_w1kb$Rho_mod <- Mbel_rho_data_w1kb$Rho_kb
Mbel_rho_data_w10kb$Rho_mod <- Mbel_rho_data_w10kb$Rho_kb
Mbel_rho_data_w100kb$Rho_mod <- Mbel_rho_data_w100kb$Rho_kb

Mbel_rho_data_w1kb_high_rho <- subset(Mbel_rho_data_w1kb, Rho_kb >= Mbel_x_max1)
Mbel_rho_data_w10kb_high_rho <- subset(Mbel_rho_data_w10kb, Rho_kb >= Mbel_x_max10)
Mbel_rho_data_w100kb_high_rho <- subset(Mbel_rho_data_w100kb, Rho_kb >= Mbel_x_max100)

Mbel_rho_data_w1kb$Rho_mod[Mbel_rho_data_w1kb_high_rho$IDX] <- Mbel_x_max1
Mbel_rho_data_w10kb$Rho_mod[Mbel_rho_data_w10kb_high_rho$IDX] <- Mbel_x_max10
Mbel_rho_data_w100kb$Rho_mod[Mbel_rho_data_w100kb_high_rho$IDX] <- Mbel_x_max100



#******************************** Amel ******************************

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_vs_genome_prop/Wallberg_honeybee_recombination_rates_2015/recombination_rates")

Amel_rho_data_w1kb <- read.table("A.rates.1000.201.low_penalty.csv.windows.1000.csv_NA",header=FALSE,col.names = c("Chrom","Start","Chrom_idx","Rho_kb"))
Amel_rho_data_w10kb <- read.table("A.rates.1000.201.low_penalty.csv.windows.10000.csv_NA",header=FALSE,col.names = c("Chrom","Start","Chrom_idx","Rho_kb"))
Amel_rho_data_w100kb <- read.table("A.rates.1000.201.low_penalty.csv.windows.100000.csv_NA",header=FALSE,col.names = c("Chrom","Start","Chrom_idx","Rho_kb"))

Amel_x_max1 <- mean(Amel_rho_data_w1kb$Rho_kb,na.rm=TRUE) + sd_factor*sd(Amel_rho_data_w1kb$Rho_kb,na.rm=TRUE)
print(Amel_x_max1)
Amel_x_max10 <- mean(Amel_rho_data_w10kb$Rho_kb,na.rm=TRUE) + sd_factor*sd(Amel_rho_data_w10kb$Rho_kb,na.rm=TRUE)
print(Amel_x_max10)
Amel_x_max100 <- mean(Amel_rho_data_w100kb$Rho_kb,na.rm=TRUE) + sd_factor*sd(Amel_rho_data_w100kb$Rho_kb,na.rm=TRUE)
print(Amel_x_max100)

hist(Amel_rho_data_w1kb$Rho_kb,col="slateblue",breaks=30,main="A. mellifera, wind. size 1 kbp",xlim=c(0,Amel_x_max1),xlab=paste("Rho/kbp, truncated at mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val)
hist(Amel_rho_data_w10kb$Rho_kb,col="slateblue",breaks=30,main="Wind. size 10 kbp",xlim=c(0,Amel_x_max10),xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val)
hist(Amel_rho_data_w100kb$Rho_kb,col="slateblue",breaks=20,main="Wind. size 100 kbp",xlim=c(0,Amel_x_max100),xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val)

Amel_rho_data_w1kb$IDX <- 1:nrow(Amel_rho_data_w1kb)
Amel_rho_data_w10kb$IDX <- 1:nrow(Amel_rho_data_w10kb)
Amel_rho_data_w100kb$IDX <- 1:nrow(Amel_rho_data_w100kb)

Amel_rho_data_w1kb$Rho_mod <- Amel_rho_data_w1kb$Rho_kb
Amel_rho_data_w10kb$Rho_mod <- Amel_rho_data_w10kb$Rho_kb
Amel_rho_data_w100kb$Rho_mod <- Amel_rho_data_w100kb$Rho_kb

Amel_rho_data_w1kb_high_rho <- subset(Amel_rho_data_w1kb, Rho_kb >= Amel_x_max1)
Amel_rho_data_w10kb_high_rho <- subset(Amel_rho_data_w10kb, Rho_kb >= Amel_x_max10)
Amel_rho_data_w100kb_high_rho <- subset(Amel_rho_data_w100kb, Rho_kb >= Amel_x_max100)

Amel_rho_data_w1kb$Rho_mod[Amel_rho_data_w1kb_high_rho$IDX] <- Amel_x_max1
Amel_rho_data_w10kb$Rho_mod[Amel_rho_data_w10kb_high_rho$IDX] <- Amel_x_max10
Amel_rho_data_w100kb$Rho_mod[Amel_rho_data_w100kb_high_rho$IDX] <- Amel_x_max100


#********************************************************************
# Histograms where values higher than x_max have been replaced by x_max
# Different x-axis limits for all plots...

wtd.hist(Csec_rho_data_w1kb$Rho_mod,weight=Csec_rho_data_w1kb$seq_len_with_data_bp,col="slateblue",breaks=60,main="C. secundus, wind. size 1 kbp",xlab=paste("Rho/kbp, highest bin = all values > mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Csec_x_max1))
wtd.hist(Csec_rho_data_w10kb$Rho_mod,weight=Csec_rho_data_w10kb$seq_len_with_data_bp,col="slateblue",breaks=50,main="Wind. size 10 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Csec_x_max10))
wtd.hist(Csec_rho_data_w100kb$Rho_mod,weight=Csec_rho_data_w100kb$seq_len_with_data_bp,col="slateblue",breaks=60,main="Wind. size 100 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Csec_x_max100))

wtd.hist(Mbel_rho_data_w1kb$Rho_mod,weight=Mbel_rho_data_w1kb$seq_len_with_data_bp,col="slateblue",breaks=80,main="M. bellicosus, wind. size 1 kbp",xlab=paste("Rho/kbp, highest bin = all values > mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Mbel_x_max1))
wtd.hist(Mbel_rho_data_w10kb$Rho_mod,weight=Mbel_rho_data_w10kb$seq_len_with_data_bp,col="slateblue",breaks=70,main="Wind. size 10 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Mbel_x_max10))
wtd.hist(Mbel_rho_data_w100kb$Rho_mod,weight=Mbel_rho_data_w100kb$seq_len_with_data_bp,col="slateblue",breaks=70,main="Wind. size 100 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Mbel_x_max100))

hist(Amel_rho_data_w1kb$Rho_mod,col="slateblue",breaks=40,main="A. mellifera, wind. size 1 kbp",xlab=paste("Rho/kbp, highest bin = all values > mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Amel_x_max1))
hist(Amel_rho_data_w10kb$Rho_mod,col="slateblue",breaks=40,main="Wind. size 10 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Amel_x_max10))
hist(Amel_rho_data_w100kb$Rho_mod,col="slateblue",breaks=30,main="Wind. size 100 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,Amel_x_max100))

#********************************************************************
# Same x-axis for all plots for the same species
# Breaks between bins are specified by vectors below, left-closed, right-open intervals as "right=FALSE" in hist-call
# All values equal to the x_max-limit are included in the bin starting at the x_max-limit (so that no lower values are included in this bin)
# All intervals don't have the same size, but should not matter. The last bin is big but contains no values (as it is > x_max)
# and the bin before x_max could be a bit bigger as well but contains very few values so no visual difference in the plots
# Can ignore warnings about areas in the plots being wrong

Csec_br_list1 <- c(seq(0,(Csec_x_max1-1)),Csec_x_max1,(Csec_x_max1+1),50)
Csec_br_list10 <- c(seq(0,(Csec_x_max10-1)),Csec_x_max10,(Csec_x_max10+1),50)
Csec_br_list100 <- c(seq(0,(Csec_x_max100-1)),Csec_x_max100,(Csec_x_max100+1),50)

Mbel_br_list1 <- c(seq(0,(Mbel_x_max1-0.5),by=0.5),Mbel_x_max1,(Mbel_x_max1+0.5),25)
Mbel_br_list10 <- c(seq(0,(Mbel_x_max10-0.5),by=0.5),Mbel_x_max10,(Mbel_x_max10+0.5),25)
Mbel_br_list100 <- c(seq(0,(Mbel_x_max100-0.5),by=0.5),Mbel_x_max100,(Mbel_x_max100+0.5),25)

Amel_br_list1 <- c(seq(0,(Amel_x_max1-25),by=25),Amel_x_max1,(Amel_x_max1+25),1200)
Amel_br_list10 <- c(seq(0,(Amel_x_max10-25),by=25),Amel_x_max10,(Amel_x_max10+25),1200)
Amel_br_list100 <- c(seq(0,(Amel_x_max100-25),by=25),Amel_x_max100,(Amel_x_max100+25),1200)

wtd.hist(Csec_rho_data_w1kb$Rho_mod,weight=Csec_rho_data_w1kb$seq_len_with_data_bp,col="slateblue",breaks=Csec_br_list1,main="C. secundus, wind. size 1 kbp",xlab=paste("Rho/kbp, highest bin = all values > mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,50),right=FALSE,freq=TRUE)
abline(v=Csec_x_max1,lty=2)
wtd.hist(Csec_rho_data_w10kb$Rho_mod,weight=Csec_rho_data_w10kb$seq_len_with_data_bp,col="slateblue",breaks=Csec_br_list10,main="Wind. size 10 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,50),right=FALSE,freq=TRUE)
abline(v=Csec_x_max10,lty=2)
wtd.hist(Csec_rho_data_w100kb$Rho_mod,weight=Csec_rho_data_w100kb$seq_len_with_data_bp,col="slateblue",breaks=Csec_br_list100,main="Wind. size 100 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,50),right=FALSE,freq=TRUE)
abline(v=Csec_x_max100,lty=2)

wtd.hist(Mbel_rho_data_w1kb$Rho_mod,weight=Mbel_rho_data_w1kb$seq_len_with_data_bp,col="slateblue",breaks=Mbel_br_list1,main="M. bellicosus, wind. size 1 kbp",xlab=paste("Rho/kbp, highest bin = all values > mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,25),right=FALSE,freq=TRUE)
abline(v=Mbel_x_max1,lty=2)
wtd.hist(Mbel_rho_data_w10kb$Rho_mod,weight=Mbel_rho_data_w10kb$seq_len_with_data_bp,col="slateblue",breaks=Mbel_br_list10,main="Wind. size 10 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,25),right=FALSE,freq=TRUE)
abline(v=Mbel_x_max10,lty=2)
wtd.hist(Mbel_rho_data_w100kb$Rho_mod,weight=Mbel_rho_data_w100kb$seq_len_with_data_bp,col="slateblue",breaks=Mbel_br_list100,main="Wind. size 100 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,25),right=FALSE,freq=TRUE)
abline(v=Mbel_x_max100,lty=2)

hist(Amel_rho_data_w1kb$Rho_mod,col="slateblue",breaks=Amel_br_list1,main="A. mellifera, wind. size 1 kbp",xlab=paste("Rho/kbp, highest bin = all values > mean+",sd_factor,"*stdev",sep=""),cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,1200),right=FALSE,freq=TRUE)
abline(v=Amel_x_max1,lty=2)
hist(Amel_rho_data_w10kb$Rho_mod,col="slateblue",breaks=Amel_br_list10,main="Wind. size 10 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,1200),right=FALSE,freq=TRUE)
abline(v=Amel_x_max10,lty=2)
hist(Amel_rho_data_w100kb$Rho_mod,col="slateblue",breaks=Amel_br_list100,main="Wind. size 100 kbp",xlab="",ylab="",cex.axis=cex_val,cex.lab=cex_val,xlim=c(0,1200),right=FALSE,freq=TRUE)
abline(v=Amel_x_max100,lty=2)

#*************

print(nrow(Csec_rho_data_w1kb_high_rho))
print(nrow(Csec_rho_data_w1kb))
print(nrow(Csec_rho_data_w1kb_high_rho)/nrow(Csec_rho_data_w1kb))

print(nrow(Mbel_rho_data_w1kb_high_rho))
print(nrow(Mbel_rho_data_w1kb))
print(nrow(Mbel_rho_data_w1kb_high_rho)/nrow(Mbel_rho_data_w1kb))

print(nrow(Amel_rho_data_w1kb_high_rho))
print(nrow(Amel_rho_data_w1kb))
print(nrow(Amel_rho_data_w1kb_high_rho)/nrow(Amel_rho_data_w1kb))


