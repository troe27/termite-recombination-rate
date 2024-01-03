rm(list=ls())

library(ggplot2)

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat")

Mbel_scaffold_lengths <- read.table("Mbel_scaffolds_lengths_final_set_sorted.txt",header=FALSE,row.names=1)

num_scaffolds_Mbel <- nrow(Mbel_scaffold_lengths)

Mbel_scaffold_lengths$IDX <- 1:num_scaffolds_Mbel

Mbel_scaffold_lengths$Cum_len_longer_scaff <- rep(0,num_scaffolds_Mbel)

Mbel_scaffold_lengths$Cum_mid_pos <- rep(0,num_scaffolds_Mbel)
Mbel_scaffold_lengths$Cum_mid_pos[1] <- Mbel_scaffold_lengths$V2[1]/2

for (i in 2:nrow(Mbel_scaffold_lengths)){
  Mbel_scaffold_lengths$Cum_len_longer_scaff[i] <- Mbel_scaffold_lengths$Cum_len_longer_scaff[(i-1)] + Mbel_scaffold_lengths$V2[(i-1)]
  Mbel_scaffold_lengths$Cum_mid_pos[i] <- Mbel_scaffold_lengths$Cum_len_longer_scaff[i] + Mbel_scaffold_lengths$V2[i]/2
}

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Mbel_100N/filt_MQ_val_70_depth_2stdev_from_mean")

Mbel_rho_data_w100kb <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt_w100kb",header=TRUE)
Mbel_rho_data_w10kb <- read.table("concat_Mbel_excl5scaff_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_100N_filtMQ70depth2stdev.txt_w10kb",header=TRUE)
#Scaffold	Start_bp	End_bp	Rho_kb	seq_len_with_data_bp

Mbel_rho_data_w100kb$IDX <- 1:nrow(Mbel_rho_data_w100kb)
Mbel_rho_data_w100kb$Tot_start <- Mbel_rho_data_w100kb$Start_bp
Mbel_rho_data_w100kb$Tot_end <- Mbel_rho_data_w100kb$End_bp
Mbel_rho_data_w100kb$Tot_mid <- (Mbel_rho_data_w100kb$Start_bp + Mbel_rho_data_w100kb$End_bp)/2

for (scaffold in row.names(Mbel_scaffold_lengths)){
  to_update_rho <- subset(Mbel_rho_data_w100kb,Scaffold==scaffold)
  Mbel_rho_data_w100kb$Tot_start[to_update_rho$IDX] <- Mbel_rho_data_w100kb$Tot_start[to_update_rho$IDX] + Mbel_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Mbel_rho_data_w100kb$Tot_end[to_update_rho$IDX] <- Mbel_rho_data_w100kb$Tot_end[to_update_rho$IDX] + Mbel_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Mbel_rho_data_w100kb$Tot_mid[to_update_rho$IDX] <- Mbel_rho_data_w100kb$Tot_mid[to_update_rho$IDX] + Mbel_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
}

Mbel_rho_w100kb_order <- order(Mbel_rho_data_w100kb$Tot_start)
Mbel_rho_w100kb_sorted <- Mbel_rho_data_w100kb[Mbel_rho_w100kb_order,]
rm(Mbel_rho_data_w100kb)
rm(Mbel_rho_w100kb_order)

Mbel_rho_data_w10kb$IDX <- 1:nrow(Mbel_rho_data_w10kb)
Mbel_rho_data_w10kb$Tot_start <- Mbel_rho_data_w10kb$Start_bp
Mbel_rho_data_w10kb$Tot_end <- Mbel_rho_data_w10kb$End_bp
Mbel_rho_data_w10kb$Tot_mid <- (Mbel_rho_data_w10kb$Start_bp + Mbel_rho_data_w10kb$End_bp)/2

for (scaffold in row.names(Mbel_scaffold_lengths)){
  to_update_rho <- subset(Mbel_rho_data_w10kb,Scaffold==scaffold)
  Mbel_rho_data_w10kb$Tot_start[to_update_rho$IDX] <- Mbel_rho_data_w10kb$Tot_start[to_update_rho$IDX] + Mbel_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Mbel_rho_data_w10kb$Tot_end[to_update_rho$IDX] <- Mbel_rho_data_w10kb$Tot_end[to_update_rho$IDX] + Mbel_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Mbel_rho_data_w10kb$Tot_mid[to_update_rho$IDX] <- Mbel_rho_data_w10kb$Tot_mid[to_update_rho$IDX] + Mbel_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
}

Mbel_rho_w10kb_order <- order(Mbel_rho_data_w10kb$Tot_start)
Mbel_rho_w10kb_sorted <- Mbel_rho_data_w10kb[Mbel_rho_w10kb_order,]
rm(Mbel_rho_data_w10kb)
rm(Mbel_rho_w10kb_order)

#********************

Mbel_rho_w100kb_sorted_subset <- subset(Mbel_rho_w100kb_sorted,Scaffold =="scaffold2")
Mbel_rho_w10kb_sorted_subset <- subset(Mbel_rho_w10kb_sorted,Scaffold =="scaffold2")

Mbel_rho_w100kb_sorted_subset$Mid_bp <- (Mbel_rho_w100kb_sorted_subset$Start_bp+Mbel_rho_w100kb_sorted_subset$End_bp)/2
Mbel_rho_w10kb_sorted_subset$Mid_bp <- (Mbel_rho_w10kb_sorted_subset$Start_bp+Mbel_rho_w10kb_sorted_subset$End_bp)/2

xmarks <- c(seq(5000,50000,by=10000))

plot(Mbel_rho_w10kb_sorted_subset$Mid_bp,Mbel_rho_w10kb_sorted_subset$Rho_kb,col="wheat3",type="p",pch=20,cex=1,xlab="Scaffold 2, positions in Kbp", ylab="Rho/kb",main="Mbel",cex.lab=1.4,cex.axis=1.4,xaxt="n")
points(Mbel_rho_w100kb_sorted_subset$Mid_bp,Mbel_rho_w100kb_sorted_subset$Rho_kb,col="firebrick4",type="p",pch=20,cex=1.3)
legend("topright",c("10 kb windows","100 kb windows"),pch=20,col=c("wheat3","firebrick4"),cex=1.4)
axis(1,labels=xmarks,at=xmarks*1000,cex.axis=1.4)
#axis(1,labels=Mbel_rho_w100kb_sorted_subset$Start_bp[seq(20,nrow(Mbel_rho_w100kb_sorted_subset),by=40)]/1000,at=Mbel_rho_w100kb_sorted_subset$Start_bp[seq(20,nrow(Mbel_rho_w100kb_sorted_subset),by=40)],cex.axis=1.4)


#*******************
# #Manhattan plot
#
# num_scaffolds_manhattan <- 30
# Mbel_scaffold_lengths_manhattan <- Mbel_scaffold_lengths[1:num_scaffolds_manhattan,]
#
# col_list_Mbel1 <- rep(c("thistle4","wheat3"),length.out=num_scaffolds_Mbel)
# names(col_list_Mbel1) <- row.names(Mbel_scaffold_lengths)
# 
# # Plot rho
# Mbel_rho_plot <- ggplot(subset(Mbel_rho_sorted,Scaffold %in% row.names(Mbel_scaffold_lengths_manhattan)),aes(Tot_mid,Rho_kb)) +
#   geom_point(aes(colour=Scaffold,shape="."),size=0.8) +
#   scale_color_manual(values=col_list_Mbel1) +
#   scale_x_continuous(label=Mbel_scaffold_lengths_manhattan$IDX, breaks=Mbel_scaffold_lengths_manhattan$Cum_mid_pos, expand=expand_scale(mult=0.02,add=0)) + #label=rownames(contig_lengths)
#   xlab("Scaffold") +
#   ylab(paste("Mbel Rho, bpen1, ",wsize,sep="")) +
#   theme(axis.text.x=element_text(size=10),
#         axis.text.y=element_text(size=12),
#         axis.title=element_text(size=12),
#         axis.ticks.x=element_blank(),
#         axis.line=element_line(color="black",size=0.2),
#         panel.background=element_blank(),
#         panel.border=element_blank(),
#         panel.grid.major.x=element_blank(),
#         panel.grid.minor.x=element_blank(),
#         panel.grid.major.y=element_blank(), #element_line(colour="black",size=0.05),
#         panel.grid.minor.y=element_blank(), #element_line(colour="black",size=0.05),
#         legend.position='none',
#         plot.margin=unit(c(0.5,0.5,0.5,0.5),units="cm"),
#         plot.title=element_text(margin=margin(t=10,r=0,b=20,l=0)),
#         axis.title.y=element_text(margin=margin(t=0,r=20,b=0,l=10))) +
#   geom_vline(xintercept=Mbel_scaffold_lengths_manhattan$Cum_len_longer_scaff[-1],linetype="dashed",colour="black",size=0.1)
# 
# Mbel_rho_plot
# 
# hist(Mbel_rho_sorted$Rho_kb,col="slateblue",breaks=200,main=paste("Mbel rho/kb,",wsize))
# 
# sum(Mbel_rho_sorted$Rho_kb*Mbel_rho_sorted$seq_len_with_data_bp)/sum(Mbel_rho_sorted$seq_len_with_data_bp)
# 
# mean(Mbel_rho_sorted$Rho_kb,na.rm=TRUE)
# mean(Mbel_rho_sorted$Rho_kb,na.rm=TRUE)/1000
