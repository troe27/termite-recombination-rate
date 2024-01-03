rm(list=ls())

library(ggplot2)

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb")

Csec_scaffold_lengths <- read.table("Csec_scaffold_lengths_geq1000_sorted.txt",header=FALSE,row.names=1)

num_scaffolds_Csec <- nrow(Csec_scaffold_lengths)

Csec_scaffold_lengths$IDX <- 1:num_scaffolds_Csec

Csec_scaffold_lengths$Cum_len_longer_scaff <- rep(0,num_scaffolds_Csec)

Csec_scaffold_lengths$Cum_mid_pos <- rep(0,num_scaffolds_Csec)
Csec_scaffold_lengths$Cum_mid_pos[1] <- Csec_scaffold_lengths$V2[1]/2

for (i in 2:nrow(Csec_scaffold_lengths)){
  Csec_scaffold_lengths$Cum_len_longer_scaff[i] <- Csec_scaffold_lengths$Cum_len_longer_scaff[(i-1)] + Csec_scaffold_lengths$V2[(i-1)]
  Csec_scaffold_lengths$Cum_mid_pos[i] <- Csec_scaffold_lengths$Cum_len_longer_scaff[i] + Csec_scaffold_lengths$V2[i]/2
}

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/rho_per_wind/concat/rho_peaks_analysis/Csec_w100kb/filt_MQ_val_70_depth_2stdev_from_mean")

Csec_rho_data_w100kb <- read.table("concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w100kb",header=TRUE)
Csec_rho_data_w10kb <- read.table("concat_Csec_geq1000_rmind_hardfilt_exhet_biall_dp_qfilt_mac2_maxmiss06_phimp_LDhat_bpen1_statres_filtMQ70depth2stdev.txt_w10kb",header=TRUE)
#Scaffold	Start_bp	End_bp	Rho_kb	seq_len_with_data_bp

Csec_rho_data_w100kb$IDX <- 1:nrow(Csec_rho_data_w100kb)
Csec_rho_data_w100kb$Tot_start <- Csec_rho_data_w100kb$Start_bp
Csec_rho_data_w100kb$Tot_end <- Csec_rho_data_w100kb$End_bp
Csec_rho_data_w100kb$Tot_mid <- (Csec_rho_data_w100kb$Start_bp + Csec_rho_data_w100kb$End_bp)/2

for (scaffold in row.names(Csec_scaffold_lengths)){
  to_update_rho <- subset(Csec_rho_data_w100kb,Scaffold==scaffold)
  Csec_rho_data_w100kb$Tot_start[to_update_rho$IDX] <- Csec_rho_data_w100kb$Tot_start[to_update_rho$IDX] + Csec_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Csec_rho_data_w100kb$Tot_end[to_update_rho$IDX] <- Csec_rho_data_w100kb$Tot_end[to_update_rho$IDX] + Csec_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Csec_rho_data_w100kb$Tot_mid[to_update_rho$IDX] <- Csec_rho_data_w100kb$Tot_mid[to_update_rho$IDX] + Csec_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
}

Csec_rho_w100kb_order <- order(Csec_rho_data_w100kb$Tot_start)
Csec_rho_w100kb_sorted <- Csec_rho_data_w100kb[Csec_rho_w100kb_order,]
rm(Csec_rho_data_w100kb)
rm(Csec_rho_w100kb_order)

Csec_rho_data_w10kb$IDX <- 1:nrow(Csec_rho_data_w10kb)
Csec_rho_data_w10kb$Tot_start <- Csec_rho_data_w10kb$Start_bp
Csec_rho_data_w10kb$Tot_end <- Csec_rho_data_w10kb$End_bp
Csec_rho_data_w10kb$Tot_mid <- (Csec_rho_data_w10kb$Start_bp + Csec_rho_data_w10kb$End_bp)/2

for (scaffold in row.names(Csec_scaffold_lengths)){
  to_update_rho <- subset(Csec_rho_data_w10kb,Scaffold==scaffold)
  Csec_rho_data_w10kb$Tot_start[to_update_rho$IDX] <- Csec_rho_data_w10kb$Tot_start[to_update_rho$IDX] + Csec_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Csec_rho_data_w10kb$Tot_end[to_update_rho$IDX] <- Csec_rho_data_w10kb$Tot_end[to_update_rho$IDX] + Csec_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
  Csec_rho_data_w10kb$Tot_mid[to_update_rho$IDX] <- Csec_rho_data_w10kb$Tot_mid[to_update_rho$IDX] + Csec_scaffold_lengths[scaffold,"Cum_len_longer_scaff"]
}

Csec_rho_w10kb_order <- order(Csec_rho_data_w10kb$Tot_start)
Csec_rho_w10kb_sorted <- Csec_rho_data_w10kb[Csec_rho_w10kb_order,]
rm(Csec_rho_data_w10kb)
rm(Csec_rho_w10kb_order)

Csec_rho_w100kb_sorted_subset <- subset(Csec_rho_w100kb_sorted,Scaffold %in% c("NEVH01000598.1","NEVH01006721.1","NEVH01024940.1"))
Csec_rho_w10kb_sorted_subset <- subset(Csec_rho_w10kb_sorted,Scaffold %in% c("NEVH01000598.1","NEVH01006721.1","NEVH01024940.1"))

plot(Csec_rho_w10kb_sorted_subset$Tot_mid,Csec_rho_w10kb_sorted_subset$Rho_kb,col="wheat3",type="p",pch=20,cex=1,xlab="Three longest scaffolds, positions in Kbp", ylab="Rho/kb",main="Csec",cex.lab=1.4,cex.axis=1.4,xaxt="n")
points(Csec_rho_w100kb_sorted_subset$Tot_mid,Csec_rho_w100kb_sorted_subset$Rho_kb,col="firebrick4",type="p",pch=20,cex=1.3)
legend("topright",c("10 kb windows","100 kb windows"),pch=20,col=c("wheat3","firebrick4"),cex=1.4)
abline(v=Csec_scaffold_lengths$Cum_len_longer_scaff[2],lty=2,lwd=2)
abline(v=Csec_scaffold_lengths$Cum_len_longer_scaff[3],lty=2,lwd=2)
axis(1,labels=Csec_rho_w100kb_sorted_subset$Start_bp[seq(1,nrow(Csec_rho_w100kb_sorted_subset),by=20)]/1000,at=Csec_rho_w100kb_sorted_subset$Tot_start[seq(1,nrow(Csec_rho_w100kb_sorted_subset),by=20)],cex.axis=1.4)

#*****************
# Manhattan plot
#
# num_scaffolds_manhattan <- 80
# Csec_scaffold_lengths_manhattan <- Csec_scaffold_lengths[1:num_scaffolds_manhattan,]
# 
# col_list_Csec1 <- rep(c("thistle4","wheat3"),length.out=num_scaffolds_Csec)
# names(col_list_Csec1) <- row.names(Csec_scaffold_lengths)
# 
# # Plot rho
# Csec_rho_plot <- ggplot(subset(Csec_rho_sorted,Scaffold %in% row.names(Csec_scaffold_lengths_manhattan)),aes(Tot_mid,Rho_kb)) +
#   geom_point(aes(colour=Scaffold,shape="."),size=0.8) +
#   scale_color_manual(values=col_list_Csec1) +
#   scale_x_continuous(label=Csec_scaffold_lengths_manhattan$IDX, breaks=Csec_scaffold_lengths_manhattan$Cum_mid_pos, expand=expand_scale(mult=0.02,add=0)) + #label=rownames(contig_lengths)
#   xlab("Scaffold") +
#   ylab(paste("Csec Rho, bpen1, ",wsize,sep="")) +
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
#   geom_vline(xintercept=Csec_scaffold_lengths_manhattan$Cum_len_longer_scaff[-1],linetype="dashed",colour="black",size=0.1)
# 
# Csec_rho_plot
# 
# hist(Csec_rho_sorted$Rho_kb,col="slateblue",breaks=100,main=paste("Csec rho/kb,",wsize))
# 
# sum(Csec_rho_sorted$Rho_kb*Csec_rho_sorted$seq_len_with_data_bp)/sum(Csec_rho_sorted$seq_len_with_data_bp)
# 
# mean(Csec_rho_sorted$Rho_kb,na.rm=TRUE)
# mean(Csec_rho_sorted$Rho_kb,na.rm=TRUE)/1000
