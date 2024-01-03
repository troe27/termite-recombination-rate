rm(list=ls())

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_vs_genome_prop")

Csec_rho_genome_full <- read.table("concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev_prop_final",header=TRUE)
Mbel_rho_genome_full <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev_prop_final",header=TRUE)
Amel_rho_genome_full <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_vs_genome_prop/Wallberg_honeybee_recombination_rates_2015/recombination_rates/A.rates.1000.201.low_penalty.csv_start_end_pos_resorted_dist_cum_prop",header=TRUE)
#Mrot_rho_genome <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_vs_genome_prop/Mrot/mr_ALL.rates.bp1.csv_start_end_pos_exclude_Ns_resorted_dist_cum_prop",header=TRUE) 
#Scaffold	Start_pos_bp	End_pos_bp	Dist_bp	Rho_per_kb	Rho	Cum_dist_bp	Cum_rho	Cum_dist_prop	Cum_rho_prop
#Mrot_rho_genome <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_vs_genome_prop/Mrot/cross_prop_newdata_v1.txt",header=TRUE)

# Mrot_scaff_list <- unique(Mrot_rho_genome_all$Scaffold)
# Mrot_num_scaff <- length(Mrot_scaff_list)
# Mrot_scaff_lengths <- data.frame(len_bp=rep(0,Mrot_num_scaff),row.names=Mrot_scaff_list)
# 
# for (scaff in Mrot_scaff_list){
#   scaff_subset <- subset(Mrot_rho_genome_all,Scaffold==scaff)
#   Mrot_scaff_lengths[scaff,"len_bp"] <- max(scaff_subset$End_pos_bp,na.rm=TRUE)
# }
# 
# min_len <- 30000
# 
# Mrot_scaff_to_keep <- subset(Mrot_scaff_lengths,len_bp>=min_len)
# 
# Mrot_rho_genome <- subset(Mrot_rho_genome_all,Scaffold %in% row.names(Mrot_scaff_to_keep))

# par(mfrow=c(1,2))
# 
# plot(Csec_rho_genome$Cum_dist_prop,Csec_rho_genome$Cum_rho_prop,type="p",pch=".",main="Csec, final filtering")
# plot(Mbel_rho_genome$Cum_dist_prop,Mbel_rho_genome$Cum_rho_prop,type="p",pch=".",main="Mbel, final filtering")

#min_len <- 0

Csec_col <- "darkgoldenrod2"
Mbel_col <- "brown4"
Amel_col <- "dodgerblue4"

# Csec_rho_genome <- Csec_rho_genome_full[sample(nrow(Csec_rho_genome_full),size=nrow(Csec_rho_genome_full)/30,replace=FALSE),]
# Mbel_rho_genome <- Mbel_rho_genome_full[sample(nrow(Mbel_rho_genome_full),size=nrow(Mbel_rho_genome_full)/30,replace=FALSE),]
# Amel_rho_genome <- Amel_rho_genome_full[sample(nrow(Amel_rho_genome_full),size=nrow(Amel_rho_genome_full)/30,replace=FALSE),]

Csec_rho_genome <- Csec_rho_genome_full[seq(1,nrow(Csec_rho_genome_full),by=3000),]
Mbel_rho_genome <- Mbel_rho_genome_full[seq(1,nrow(Mbel_rho_genome_full),by=3000),]
Amel_rho_genome <- Amel_rho_genome_full[seq(1,nrow(Amel_rho_genome_full),by=3000),]

# rm(Csec_rho_genome_full)
# rm(Mbel_rho_genome_full)
# rm(Amel_rho_genome_full)

par(mfrow=c(1,1))
plot(Csec_rho_genome$Cum_dist_prop,Csec_rho_genome$Cum_rho_prop,type="p",pch=".",cex=2,col=Csec_col,main=paste("Termites final filt",sep=""))
points(Mbel_rho_genome$Cum_dist_prop,Mbel_rho_genome$Cum_rho_prop,type="p",pch=".",cex=2,col=Mbel_col)
points(Amel_rho_genome$Cum_dist_prop,Amel_rho_genome$Cum_rho_prop,type="p",pch=".",cex=2,col=Amel_col)
#points(Mrot_rho_genome$Cum_dist_prop,Mrot_rho_genome$Cum_rho_prop,type="p",pch=".",cex=1.5,col="darkgoldenrod2")
#points(Mrot_rho_genome$Proportion_of_genome,Mrot_rho_genome$Proportion_of_crossover,type="p",pch=".",cex=1.5,col="darkgoldenrod2")
legend("bottomright",c("C. secundus","M. bellicosus","A. mellifera"),col=c(Csec_col,Mbel_col,Amel_col),pch=20)

Csec_05 <- subset(Csec_rho_genome_full,Cum_rho_prop>0.4999 & Cum_rho_prop<0.5001)
Csec_05_mean <- mean(Csec_05$Cum_dist_prop,na.rm=TRUE)

Mbel_05 <- subset(Mbel_rho_genome_full,Cum_rho_prop>0.4999 & Cum_rho_prop<0.5001)
Mbel_05_mean <- mean(Mbel_05$Cum_dist_prop,na.rm=TRUE)

Amel_05 <- subset(Amel_rho_genome_full,Cum_rho_prop>0.4999 & Cum_rho_prop<0.5001)
Amel_05_mean <- mean(Amel_05$Cum_dist_prop,na.rm=TRUE)

# Mrot_05 <- subset(Mrot_rho_genome,Cum_rho_prop>0.4999 & Cum_rho_prop<0.5001)
# Mrot_05_mean <- mean(Mrot_05$Cum_dist_prop,na.rm=TRUE)

# Mrot_05 <- subset(Mrot_rho_genome, Proportion_of_crossover>0.4999 & Proportion_of_crossover<0.5001)
# Mrot_05_mean <- mean(Mrot_05$Proportion_of_genome,na.rm=TRUE)

abline(h=0.5,lty=2,col="gray60",lwd=1.5)
lines(c(Csec_05_mean,Csec_05_mean),c(0,0.5),col=Csec_col,lty=2,lwd=1.5)
lines(c(Mbel_05_mean,Mbel_05_mean),c(0,0.5),col=Mbel_col,lty=2,lwd=1.5)
lines(c(Amel_05_mean,Amel_05_mean),c(0,0.5),col=Amel_col,lty=2,lwd=1.5)
#lines(c(Mrot_05_mean,Mrot_05_mean),c(0,0.5),col="darkgoldenrod2",lty=2)

