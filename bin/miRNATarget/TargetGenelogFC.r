targetscan<-read.table(file="../../../bin/TargetScan/Predicted_Targets_Context_Scores.default_predictions.txt",header=T,sep="\t")
miRNAlist<-unique(targetscan[which(targetscan[,4]=="9606"),5])

for (miRNA in miRNAlist){

#miRNA="hsa-miR-25-3p"
target<-targetscan[(targetscan[,5]==miRNA) & targetscan[,4]=="9606",c(2,12)]
names(target)<-c("gene","percentile")
toptarget<-target[target$percentile>90,1]
write.table(target,file=paste(miRNA,"target",sep="_"),row.names=F,col.names=F,quote=F)
write.table(toptarget,file=paste(miRNA,"toptarget",sep="_"),row.names=F,col.names=F,quote=F)
length(toptarget)
dim(target)
DE<-read.table(file="../gene_exp.diff",header=T,row.names=1)
DE<-DE[(DE$value_1+DE$value_2)>1,]
allgene<-row.names(DE)
nottarget<-setdiff(allgene,target$gene)
random<-sample(nottarget,5000)
random<-nottarget

if (length(toptarget)<10){
next
}

targetDE<-merge(target,DE,by="gene")

random<-data.frame(random)
names(random)<-"gene"
randomDE<-merge(random,DE,by="gene")

toptarget<-data.frame(toptarget)
names(toptarget)<-"gene"
toptargetDE<-merge(toptarget,DE,by="gene")

targetDE<-targetDE[is.finite(targetDE$log2.fold_change.),]$log2.fold_change.
randomDE<-randomDE[is.finite(randomDE$log2.fold_change.),]$log2.fold_change.
toptargetDE<-toptargetDE[is.finite(toptargetDE$log2.fold_change.),]$log2.fold_change.

targetDE<-data.frame(targetDE)
targetDE$Type="Target"
names(targetDE)<-c("logFC","Type")
randomDE<-data.frame(randomDE)
randomDE$Type="Random"
names(randomDE)<-c("logFC","Type")
toptargetDE<-data.frame(toptargetDE)
toptargetDE$Type<-"Toptarget"
names(toptargetDE)<-c("logFC","Type")

p<-t.test(randomDE$logFC,toptargetDE$logFC)$p.value
p<-paste(miRNA,p,sep=":")
print(p)

plotDE<-rbind(targetDE,randomDE,toptargetDE)

library(ggplot2)
p<-ggplot(plotDE,aes(x=logFC,color=Type)) + geom_step(aes(y=..y..),size=2,stat="ecdf")+
       scale_color_brewer(palette="Set2")+
       theme_classic()+
       theme( axis.title.x = element_text(size = 35,colour="black"),
            axis.text.y = element_text(size = 35,colour="black"),
            axis.text.x = element_text(size = 35,colour="black"),
            axis.title.y = element_text(size = 35,colour="black"))+
      xlab("mRNA log2FC")+
      ylab("Cumulative fraction")+
      xlim(-1,1)+
      theme(legend.text=element_text(size=35))+
      theme(legend.title=element_text(size=35))+
      theme(legend.position="right")+
      theme(axis.line = element_line(colour = 'black', size = 2))
      
      
pdffile=paste0(miRNA,"TargetDE.cummulativesplot.pdf");
ggsave(pdffile,width =10,height=6)

}
