rm(list=ls())

setwd("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/PopLDdecay/final_filt")

Csec_LD <- read.table("Csec_concat_geq1000_rmind_hard_filt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_popLD_max10kb.stat",header=TRUE)
Mbel_LD <- read.table("Mbel_concat_excl5scaff_rmind_hard_filt_exhet_biall_dp_qfilt_mac2_maxmiss06_rmfilt_sedmiss_phimp_MQ70_dp2stdev_v4_PopLD_max10kb.stat",header=TRUE)
Amel_LD <- read.table("/home/turid/Documents/HoneyBees/termites/resuming_project_2023/PopLDdecay/Amel_scutellata/kenyan_scu_rmind_hardfilt_excesshet_biall_dp_qualfilt_mac2_maxmiss06_rmfilt_ph_imp.vcf_LDdecay_max10kb.stat",header=TRUE)

maxy <- max(c(max(Csec_LD$Mean_r.2,na.rm=TRUE),max(Mbel_LD$Mean_r.2,na.rm=TRUE), max(Amel_LD$Mean_r.2,na.rm=TRUE)))

Csec_col <- "darkgoldenrod2"
Mbel_col <- "brown4"
Amel_col <- "dodgerblue4"

plot(Csec_LD$Dist, Csec_LD$Mean_r.2, type="p",pch=20,cex=0.6,col=Csec_col,main="LD decay",xlab="Distance between SNPs",ylab="r2",ylim=c(0,maxy),cex.axis=1.5,cex.lab=1.5)
lines(Mbel_LD$Dist, Mbel_LD$Mean_r.2, type="p",pch=20,cex=0.6,col=Mbel_col)
lines(Amel_LD$Dist, Amel_LD$Mean_r.2, type="p",pch=20,cex=0.6,col=Amel_col)

legend("topright",c("C. secundus","M. bellicosus","A. mellifera"),col=c(Csec_col,Mbel_col,Amel_col),pch=20,cex=1.5)

