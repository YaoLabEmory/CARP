library(DESeq2)

#step1: calculate normfactor
config<-read.table(file="../bin/config")
length<-config[which(config[,1]=="length"),2]

ARS<-read.table(file="../Rawdata/sample_names_AR.txt")[,1]
RMS<-read.table(file="../Rawdata/sample_names_RM.txt")[,1]
RMJ<-read.table(file=paste0("../MergeCirc/juncmap/",length,"bp/summary.txt"),row.names=1,header=T)
RMJ<-RMJ[RMS,2]
RMM<-read.table(file="../RNAseq/summary.txt",header=T,row.name=1)
RMM<-RMM[RMS,2]
NF<-RMJ/RMM
NF<-NF/(min(NF))

#step2: normalize
RC<-read.table(file=paste0("../MergeCirc/juncmap/",length,"bp/RC"),header=T,row.names=1)
RC<-RC[,ARS]
RC<-sweep(RC,MARGIN = 2,NF,FUN = "/")
rowname<-row.names(RC)
RC <- sapply(RC, as.integer)
row.names(RC)<-rowname
mean<-apply(RC,1,mean)
RC<-RC[mean>2,] ########Cutoff

#step3: DESeq call Diff
condition<-read.table(file="../Rawdata/condition")[,1]

colData=data.frame(condition=rev(condition))
levels(colData$condition)=reverse(c("case","control"))
dds=DESeqDataSetFromMatrix(countData =RC,colData = colData,design= ~condition)
dds=DESeq(dds)
result=results(dds)

#step4: add information
result<-as.data.frame(result)
result$fdr<-p.adjust(result$pvalue,method="fdr")
resultRC<-cbind(RC,result)

genename<-read.table(file="../MergeCirc/circlist/circlist.bed.gene")
names(genename)<-c("chr","start","end","strand","isoform","score","gene")
row.names(genename)<-paste(genename$chr,":",genename$start,"-",genename$end,sep="")
resultRC$gene<-genename[row.names(resultRC),]$gene
resultRC$circ<-row.names(resultRC)

DEgene<-read.table(file="../RNAseq/Cuffdiff/gene_exp.diff",header=T)
DEgene<-DEgene[,c(3,10,13)]

resultDEgene<-merge(resultRC,DEgene,by="gene",all.x = TRUE)
resultDEgene<-resultDEgene[order(resultDEgene$fdr),]
write.table(resultDEgene,file="DESeq.xls",row.names=FALSE,sep="\t",quote=FALSE)

#step4: Summarize up/down
DE<-read.table(file="DESeq.xls",header=T)
DEup<-DE[DE$log2FoldChange>0 & DE$fdr<0.05,]
DEdown<-DE[DE$log2FoldChange<0 & DE$fdr<0.05,]
print("DEup")
print(length(DEup$log2FoldChange))
print("DEdown")
print(length(DEdown$log2FoldChange))

write.table(DEup,file="DEup.xls",row.names=F,col.names=F,quote=F,sep="\t")
write.table(DEdown,file="DEdown.xls",row.names=F,col.names=F,quote=F,sep="\t")


